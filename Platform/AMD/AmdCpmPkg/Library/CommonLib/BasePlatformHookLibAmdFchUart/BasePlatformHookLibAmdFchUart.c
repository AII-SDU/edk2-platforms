/** @file

  Copyright (C) 2016-2025 Advanced Micro Devices, Inc. All rights reserved.<BR>

  SPDX-License-Identifier: BSD-2-Clause-Patent

**/

#include <Library/IoLib.h>

/**
  Performs platform specific initialization required for the CPU to access
  the hardware associated with a SerialPortLib instance.  This function does
  not intiailzie the serial port hardware itself.  Instead, it initializes
  hardware devices that are required for the CPU to access the serial port
  hardware.  This function may be called more than once.

  @retval RETURN_SUCCESS       The platform specific initialization succeeded.
  @retval RETURN_DEVICE_ERROR  The platform specific initialization could not be completed.

**/
RETURN_STATUS
EFIAPI
PlatformHookSerialPortInitialize (
  VOID
  )
{
  return RETURN_SUCCESS;
}
