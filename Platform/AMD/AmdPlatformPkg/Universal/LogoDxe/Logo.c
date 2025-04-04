/** @file
  Logo DXE Driver, install Edk2 Platform Logo protocol.

  Copyright (c) 2016 - 2020, Intel Corporation. All rights reserved.<BR>
  Copyright (C) 2024-2025 Advanced Micro Devices, Inc. All rights reserved.

  SPDX-License-Identifier: BSD-2-Clause-Patent

**/
#include <Library/BootLogoLib.h>
#include <Library/DebugLib.h>
#include <Library/PcdLib.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Protocol/GraphicsOutput.h>
#include <Protocol/HiiDatabase.h>
#include <Protocol/HiiImageEx.h>
#include <Protocol/HiiPackageList.h>
#include <Protocol/PlatformLogo.h>
#include <Uefi.h>
#include "Logo.h"

EFI_HII_IMAGE_EX_PROTOCOL  *mHiiImageEx;
EFI_HII_HANDLE             mHiiHandle;
LOGO_ENTRY                 mLogos[] = {
  {
    IMAGE_TOKEN (IMG_LOGO),
    EdkiiPlatformLogoDisplayAttributeCenter,
    0,
    0
  }
};

/**
  Load a platform logo image and return its data and attributes.

  @param[in]      This              The pointer to this protocol instance.
  @param[in, out] Instance          The visible image instance is found.
  @param[out]     Image             Points to the image.
  @param[out]     Attribute         The display attributes of the image returned.
  @param[out]     OffsetX           The X offset of the image regarding the Attribute.
  @param[out]     OffsetY           The Y offset of the image regarding the Attribute.

  @retval EFI_SUCCESS            The image was fetched successfully.
  @retval EFI_NOT_FOUND          The specified image could not be found.
  @retval EFI_INVALID_PARAMETER  One of the given input parameters are incorrect
**/
EFI_STATUS
EFIAPI
GetImage (
  IN     EDKII_PLATFORM_LOGO_PROTOCOL        *This,
  IN OUT UINT32                              *Instance,
  OUT EFI_IMAGE_INPUT                        *Image,
  OUT EDKII_PLATFORM_LOGO_DISPLAY_ATTRIBUTE  *Attribute,
  OUT INTN                                   *OffsetX,
  OUT INTN                                   *OffsetY
  )
{
  UINT32  Current;

  if ((Instance == NULL) || (Image == NULL) ||
      (Attribute == NULL) || (OffsetX == NULL) || (OffsetY == NULL))
  {
    return EFI_INVALID_PARAMETER;
  }

  Current = *Instance;
  if (Current >= ARRAY_SIZE (mLogos)) {
    return EFI_NOT_FOUND;
  }

  (*Instance)++; // Advance to next logo.
  *Attribute = mLogos[Current].Attribute;
  *OffsetX   = mLogos[Current].OffsetX;
  *OffsetY   = mLogos[Current].OffsetY;
  return mHiiImageEx->GetImageEx (mHiiImageEx, mHiiHandle, mLogos[Current].ImageId, Image);
}

EDKII_PLATFORM_LOGO_PROTOCOL  mPlatformLogo = {
  GetImage
};

// AMD_EDKII_OVERRIDE START

/**
  After console ready before boot option event callback

  @param[in] Event      The Event this notify function registered to.
  @param[in] Context    Pointer to the context data registered to the Event.
**/
VOID
EFIAPI
LogoDxeDisplayEventCallback (
  IN EFI_EVENT  Event,
  IN VOID       *Context
  )
{
  DEBUG ((DEBUG_INFO, "AMD logo is displaying.\n"));

  BootLogoEnableLogo ();
  gBS->CloseEvent (Event);
}

/**
  Entrypoint of this module.

  This function is the entrypoint of this module. It installs the Edkii
  Platform Logo protocol.

  @param  ImageHandle       The firmware allocated handle for the EFI image.
  @param  SystemTable       A pointer to the EFI System Table.

  @retval EFI_SUCCESS       The entry point is executed successfully.

**/
EFI_STATUS
EFIAPI
InitializeLogo (
  IN EFI_HANDLE        ImageHandle,
  IN EFI_SYSTEM_TABLE  *SystemTable
  )
{
  EFI_STATUS                   Status;
  EFI_HII_PACKAGE_LIST_HEADER  *PackageList;
  EFI_HII_DATABASE_PROTOCOL    *HiiDatabase;
  EFI_HANDLE                   Handle;
  EFI_EVENT                    AfterConsoleReadyBeforeBootOptionEvent;

  Status = gBS->LocateProtocol (
                  &gEfiHiiDatabaseProtocolGuid,
                  NULL,
                  (VOID **)&HiiDatabase
                  );
  ASSERT_EFI_ERROR (Status);

  Status = gBS->LocateProtocol (
                  &gEfiHiiImageExProtocolGuid,
                  NULL,
                  (VOID **)&mHiiImageEx
                  );
  ASSERT_EFI_ERROR (Status);

  //
  // Retrieve HII package list from ImageHandle
  //
  Status = gBS->OpenProtocol (
                  ImageHandle,
                  &gEfiHiiPackageListProtocolGuid,
                  (VOID **)&PackageList,
                  ImageHandle,
                  NULL,
                  EFI_OPEN_PROTOCOL_GET_PROTOCOL
                  );
  if (EFI_ERROR (Status)) {
    DEBUG ((DEBUG_ERROR, "HII Image Package with logo not found in PE/COFF resource section\n"));
    return Status;
  }

  //
  // Publish HII package list to HII Database.
  //
  Status = HiiDatabase->NewPackageList (
                          HiiDatabase,
                          PackageList,
                          NULL,
                          &mHiiHandle
                          );
  if (!EFI_ERROR (Status)) {
    Handle = NULL;
    Status = gBS->InstallMultipleProtocolInterfaces (
                    &Handle,
                    &gEdkiiPlatformLogoProtocolGuid,
                    &mPlatformLogo,
                    NULL
                    );
    if (EFI_ERROR (Status)) {
      DEBUG ((DEBUG_ERROR, "Install protocol failed.\n"));
      return Status;
    }
  }

  //
  // Create AfterConsoleReadyBeforeBootOption event callback
  //
  Status = gBS->CreateEventEx (
                  EVT_NOTIFY_SIGNAL,
                  TPL_CALLBACK,
                  LogoDxeDisplayEventCallback,
                  NULL,
                  (EFI_GUID *)PcdGetPtr (PcdAmdDisplayLogoEventGuid),
                  &AfterConsoleReadyBeforeBootOptionEvent
                  );
  ASSERT_EFI_ERROR (Status);
  return Status;
}
