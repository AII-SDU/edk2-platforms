/** @file

Copyright (C) 2023 - 2025 Advanced Micro Devices, Inc. All rights reserved
SPDX-License-Identifier: BSD-2-Clause-Patent

**/

#ifndef DXE_BOARD_INIT_LIB_INTERNAL_H_
#define DXE_BOARD_INIT_LIB_INTERNAL_H_

#include <Uefi/UefiBaseType.h>
#include <Register/Intel/Cpuid.h>
#include <Protocol/AcpiSystemDescriptionTable.h>
#include <Library/UefiBootServicesTableLib.h>
#include <Library/DxeServicesTableLib.h>
#include <Library/DebugLib.h>
#include <Protocol/AcpiTable.h>
#include <Library/BaseMemoryLib.h>
#include <Library/MemoryAllocationLib.h>
#include <IndustryStandard/Acpi65.h>
#include <Library/SortLib.h>
#include <Library/IoLib.h>
#include <Register/AmdIoApic.h>
#include <Protocol/MpService.h>
#include <Library/BaseLib.h>

// Define temp buffer length for save IoApic data
#define MAX_IOAPIC_NUM  0x20

#define VGA_MEM_BASE  0xA0000
#define VGA_MEM_SIZE  0x20000

//
// 48-bit MMIO space (MB-aligned)
//
#define AMD_MMIO_CFG_MSR_ADDR   0xC0010058UL
#define AMD_MMIO_CFG_ADDR_MASK  0xFFFFFFF00000ULL

typedef struct {
  UINT8    Type;
  UINT8    Length;
} STRUCTURE_HEADER;

#pragma pack(1)
typedef union {
  struct {
    // HACK-HACK: Use UINT32 to keep compiler from using SHIFT intrinsics on NOOPT build
    UINT32    Enable          : 1;    // [0]
    UINT32    Reserved1       : 1;    // [1]
    UINT32    BusRange        : 4;    // [5:2]
    UINT32    Reserved2       : 14;   // [19:6]
    UINT32    MmioCfgBaseAddr : 28;   // [47:20]
    UINT32    Reserved3       : 16;   // [63:48]
  } AsBits;

  UINT64    AsUint64;
} AMD_MMIO_CFG_MSR;
#pragma pack()

/**
  Reserve PCIe Extended Config Space MMIO in the GCD and mark it runtime

  @param[in]  ImageHandle  ImageHandle of the loaded driver.
  @param[in]  SystemTable  Pointer to the EFI System Table.

  @retval  EFI_SUCCESS  One or more of the drivers returned a success code.
  @retval  !EFI_SUCCESS  Error initializing the Legacy PIC.
**/
EFI_STATUS
EFIAPI
ReservePcieExtendedConfigSpace (
  IN EFI_HANDLE        ImageHandle,
  IN EFI_SYSTEM_TABLE  *SystemTable
  );

/**
  Prototype for callback function to patch ACPI table.

  @param[in, out] NewTable            The pointer to ACPI table.
  @return         EFI_SUCCESS         Always return EFI_SUCCESS
**/
typedef
EFI_STATUS
(EFIAPI *PATCH_ACPITABLE)(
  IN OUT  EFI_ACPI_SDT_HEADER  *NewTable
  );

/**
  A helper function to update and re-install ACPI table.
  It searh for ACPI table for provided table signature,
  if found then creates a copy of the table and calls the callbackfunction.

  @param[in] Signature           ACPI table signature
  @param[in] CallbackFunction    The function to call to patch the searching ACPI table.

  @return EFI_SUCCESS            Successfully Re-install the ACPI Table
  @return EFI_NOT_FOUND          Table not found
  @return EFI_STATUS             returns non-EFI_SUCCESS value in case of failure

**/
EFI_STATUS
EFIAPI
UpdateReinstallAcpiTable (
  IN UINT32           Signature,
  IN PATCH_ACPITABLE  CallbackFunction
  );

/**
  A Callback function to patch the ACPI FADT table.
  Updates FADT table with AMD specific values, which
  are different than MinPlatformPkg.

  @param[in, out] NewTable       Pointer to ACPI FADT table

  @return         EFI_SUCCESS    Always return EFI_SUCCESSe

**/
EFI_STATUS
EFIAPI
FadtAcpiTablePatch (
  IN OUT  EFI_ACPI_SDT_HEADER  *NewTable
  );

EFI_STATUS
EFIAPI
MadtAcpiTablePatch (
  IN OUT  EFI_ACPI_SDT_HEADER  *NewTable
  );

/**
  A Callback function to patch the ACPI DSDT/SSDT table.
  Which has ASL code that needs to be updated.

  @param[in, out] NewTable       Pointer to ACPI FADT table

  @return         EFI_SUCCESS    Always return EFI_SUCCESSe

**/
EFI_STATUS
EFIAPI
AcpiTableAmlUpdate (
  IN OUT  EFI_ACPI_SDT_HEADER  *NewTable
  );

/**
  Reserve Legay VGA IO space.

  @retval  EFI_SUCCESS  MMIO at Legacy VGA region has been allocated.
  @retval  !EFI_SUCCESS Error allocating the legacy VGA region.

**/
EFI_STATUS
EFIAPI
ReserveLegacyVgaIoSpace (
  VOID
  );

#endif
