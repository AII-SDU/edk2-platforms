/** @file
Header file for BDS Hook Library

Copyright (C) 2025 Advanced Micro Devices, Inc. All rights reserved.
Copyright (c) 2020, Intel Corporation. All rights reserved.<BR>
SPDX-License-Identifier: BSD-2-Clause-Patent

**/

#ifndef _BOARD_BDS_HOOK_LIB_H_
#define _BOARD_BDS_HOOK_LIB_H_

#include <Library/UefiLib.h>
#include <Library/DevicePathLib.h>

#define BOARD_BDS_BOOT_FROM_DEVICE_PATH_PROTOCOL_GUID   \
  { 0x446a068f, 0xa755, 0x425a,                         \
    { 0xba, 0x2a, 0x1f, 0x67, 0xd3, 0xd6, 0xce, 0xe2 }}

struct _BOARD_BDS_BOOT_FROM_DEVICE_PATH_PROTOCOL {
  UINT8                     IpmiBootDeviceSelectorType;
  EFI_DEVICE_PATH_PROTOCOL  *Device;
};

typedef struct _BOARD_BDS_BOOT_FROM_DEVICE_PATH_PROTOCOL BOARD_BDS_BOOT_FROM_DEVICE_PATH_PROTOCOL;

extern EFI_GUID gBoardBdsBootFromDevicePathProtocolGuid;
/**
  This is the callback function for Bds Ready To Boot event.

  @param  Event   Pointer to this event
  @param  Context Event hanlder private data

  @retval None.
**/
VOID
EFIAPI
BdsReadyToBootCallback (
  IN  EFI_EVENT                 Event,
  IN  VOID                      *Context
  );


/**
  This is the callback function for Smm Ready To Lock event.

  @param[in] Event      The Event this notify function registered to.
  @param[in] Context    Pointer to the context data registered to the Event.
**/
VOID
EFIAPI
BdsSmmReadyToLockCallback (
  IN EFI_EVENT    Event,
  IN VOID         *Context
  );


/**
  This is the callback function for PCI ENUMERATION COMPLETE.

  @param[in] Event      The Event this notify function registered to.
  @param[in] Context    Pointer to the context data registered to the Event.
**/
VOID
EFIAPI
BdsPciEnumCompleteCallback (
  IN EFI_EVENT    Event,
  IN VOID         *Context
  );


/**
  Before console after trusted console event callback

  @param[in] Event      The Event this notify function registered to.
  @param[in] Context    Pointer to the context data registered to the Event.
**/
VOID
EFIAPI
BdsBeforeConsoleAfterTrustedConsoleCallback (
  IN EFI_EVENT          Event,
  IN VOID               *Context
  );


/**
  Before console before end of DXE event callback

  @param[in] Event      The Event this notify function registered to.
  @param[in] Context    Pointer to the context data registered to the Event.
**/
VOID
EFIAPI
BdsBeforeConsoleBeforeEndOfDxeGuidCallback (
  IN EFI_EVENT          Event,
  IN VOID               *Context
  );


/**
  After console ready before boot option event callback

  @param[in] Event      The Event this notify function registered to.
  @param[in] Context    Pointer to the context data registered to the Event.
**/
VOID
EFIAPI
BdsAfterConsoleReadyBeforeBootOptionCallback (
  IN EFI_EVENT          Event,
  IN VOID               *Context
  );

#endif
