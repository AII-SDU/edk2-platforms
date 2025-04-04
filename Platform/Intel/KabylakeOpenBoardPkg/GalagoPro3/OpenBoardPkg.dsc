## @file
#  The main build description file for the GalagoPro3 board.
#
# Copyright (c) 2019 - 2022, Intel Corporation. All rights reserved.<BR>
#
# SPDX-License-Identifier: BSD-2-Clause-Patent
#
##
[Defines]
  DEFINE      PLATFORM_PACKAGE                = MinPlatformPkg
  DEFINE      PLATFORM_SI_PACKAGE             = KabylakeSiliconPkg
  DEFINE      PLATFORM_SI_BIN_PACKAGE         = KabylakeSiliconBinPkg
  DEFINE      PLATFORM_FSP_BIN_PACKAGE        = KabylakeFspBinPkg
  DEFINE      PLATFORM_BOARD_PACKAGE          = KabylakeOpenBoardPkg
  DEFINE      BOARD                           = GalagoPro3
  DEFINE      PROJECT                         = $(PLATFORM_BOARD_PACKAGE)/$(BOARD)
  DEFINE      PEI_ARCH                        = IA32
  DEFINE      DXE_ARCH                        = X64
  DEFINE      TOP_MEMORY_ADDRESS              = 0x0

  #
  # Default value for OpenBoardPkg.fdf use
  #
  DEFINE BIOS_SIZE_OPTION = SIZE_60

  PLATFORM_NAME                               = $(PLATFORM_PACKAGE)
  PLATFORM_GUID                               = 7324F33D-4E96-4F8B-A550-544DE6162AB7
  PLATFORM_VERSION                            = 0.1
  DSC_SPECIFICATION                           = 0x00010005
  OUTPUT_DIRECTORY                            = Build/$(PROJECT)
  SUPPORTED_ARCHITECTURES                     = IA32|X64
  BUILD_TARGETS                               = DEBUG|RELEASE
  SKUID_IDENTIFIER                            = ALL

  FLASH_DEFINITION                            = $(PROJECT)/OpenBoardPkg.fdf
  FIX_LOAD_TOP_MEMORY_ADDRESS                 = 0x0

  #
  # Include PCD configuration for this board.
  #
  !include AdvancedFeaturePkg/Include/AdvancedFeaturesPcd.dsc

  !include OpenBoardPkgPcd.dsc
  !include AdvancedFeaturePkg/Include/AdvancedFeatures.dsc

################################################################################
#
# SKU Identification section - list of all SKU IDs supported by this board.
#
################################################################################
[SkuIds]
  0|DEFAULT              # The entry: 0|DEFAULT is reserved and always required.
  0x20|GalagoPro3

################################################################################
#
# Includes section - other DSC file contents included for this board build.
#
################################################################################

#######################################
# Library Includes
#######################################
!include $(PLATFORM_PACKAGE)/Include/Dsc/CoreCommonLib.dsc
!include $(PLATFORM_PACKAGE)/Include/Dsc/CorePeiLib.dsc
!include $(PLATFORM_PACKAGE)/Include/Dsc/CoreDxeLib.dsc
!include $(PLATFORM_SI_PACKAGE)/SiPkgCommonLib.dsc
!include $(PLATFORM_SI_PACKAGE)/SiPkgPeiLib.dsc
!include $(PLATFORM_SI_PACKAGE)/SiPkgDxeLib.dsc

#######################################
# Component Includes
#######################################
[Components.$(PEI_ARCH)]
!include $(PLATFORM_PACKAGE)/Include/Dsc/CorePeiInclude.dsc
!include $(PLATFORM_SI_PACKAGE)/SiPkgPei.dsc

[Components.$(DXE_ARCH)]
!include $(PLATFORM_PACKAGE)/Include/Dsc/CoreDxeInclude.dsc
!include $(PLATFORM_SI_PACKAGE)/SiPkgDxe.dsc

#######################################
# Build Option Includes
#######################################
!include $(PLATFORM_SI_PACKAGE)/SiPkgBuildOption.dsc
!include OpenBoardPkgBuildOption.dsc

################################################################################
#
# Library Class section - list of all Library Classes needed by this board.
#
################################################################################

[LibraryClasses.common]
  #######################################
  # Edk2 Packages
  #######################################
  FspWrapperApiLib|IntelFsp2WrapperPkg/Library/BaseFspWrapperApiLib/BaseFspWrapperApiLib.inf
  FspWrapperApiTestLib|IntelFsp2WrapperPkg/Library/PeiFspWrapperApiTestLib/PeiFspWrapperApiTestLib.inf

  #######################################
  # Silicon Initialization Package
  #######################################
  ConfigBlockLib|IntelSiliconPkg/Library/BaseConfigBlockLib/BaseConfigBlockLib.inf
  SiliconInitLib|$(PLATFORM_SI_PACKAGE)/Library/PeiSiliconInitLib/PeiSiliconInitLib.inf
  SiliconPolicyInitLib|$(PLATFORM_SI_PACKAGE)/Library/PeiSiliconPolicyInitLibFsp/PeiSiliconPolicyInitLibFsp.inf

  #####################################
  # Platform Package
  #####################################
  BoardInitLib|$(PLATFORM_PACKAGE)/PlatformInit/Library/BoardInitLibNull/BoardInitLibNull.inf
  FspWrapperHobProcessLib|$(PLATFORM_PACKAGE)/FspWrapper/Library/PeiFspWrapperHobProcessLib/PeiFspWrapperHobProcessLib.inf
  FspWrapperPlatformLib|$(PLATFORM_PACKAGE)/FspWrapper/Library/PeiFspWrapperPlatformLib/PeiFspWrapperPlatformLib.inf
  PciHostBridgeLib|$(PLATFORM_PACKAGE)/Pci/Library/PciHostBridgeLibSimple/PciHostBridgeLibSimple.inf
  PciSegmentInfoLib|$(PLATFORM_PACKAGE)/Pci/Library/PciSegmentInfoLibSimple/PciSegmentInfoLibSimple.inf
  PeiLib|$(PLATFORM_PACKAGE)/Library/PeiLib/PeiLib.inf
  PlatformBootManagerLib|$(PLATFORM_PACKAGE)/Bds/Library/DxePlatformBootManagerLib/DxePlatformBootManagerLib.inf
  ReportFvLib|$(PLATFORM_PACKAGE)/PlatformInit/Library/PeiReportFvLib/PeiReportFvLib.inf
  TestPointCheckLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointCheckLibNull/TestPointCheckLibNull.inf

  #######################################
  # Board Package
  #######################################
  GpioExpanderLib|$(PLATFORM_BOARD_PACKAGE)/Library/BaseGpioExpanderLib/BaseGpioExpanderLib.inf
  I2cAccessLib|$(PLATFORM_BOARD_PACKAGE)/Library/PeiI2cAccessLib/PeiI2cAccessLib.inf
  PlatformSecLib|$(PLATFORM_PACKAGE)/FspWrapper/Library/SecFspWrapperPlatformSecLib/SecFspWrapperPlatformSecLib.inf
  HdmiDebugGpioInitLib|$(PLATFORM_BOARD_PACKAGE)/Library/HdmiDebugGpioInitLib/HdmiDebugGpioInitLib.inf
  HdmiDebugPchDetectionLib|$(PLATFORM_BOARD_PACKAGE)/Library/HdmiDebugPchDetectionLib/HdmiDebugPchDetectionLib.inf

  # Thunderbolt
!if gKabylakeOpenBoardPkgTokenSpaceGuid.PcdTbtEnable == TRUE
  DxeTbtPolicyLib|$(PLATFORM_BOARD_PACKAGE)/Features/Tbt/Library/DxeTbtPolicyLib/DxeTbtPolicyLib.inf
  TbtCommonLib|$(PLATFORM_BOARD_PACKAGE)/Features/Tbt/Library/PeiDxeSmmTbtCommonLib/TbtCommonLib.inf
!endif

  #######################################
  # Board-specific
  #######################################
  PlatformHookLib|$(PROJECT)/Library/BasePlatformHookLib/BasePlatformHookLib.inf
  SiliconPolicyUpdateLib|$(PROJECT)/FspWrapper/Library/PeiSiliconPolicyUpdateLibFsp/PeiSiliconPolicyUpdateLibFsp.inf

[LibraryClasses.common.PEI_CORE]
!if $(TARGET) == DEBUG && gKabylakeOpenBoardPkgTokenSpaceGuid.PcdI2cHdmiDebugPortEnable == TRUE
  DebugLib|MdePkg/Library/BaseDebugLibSerialPort/BaseDebugLibSerialPort.inf
  SerialPortLib|$(PLATFORM_BOARD_PACKAGE)/Library/I2cHdmiDebugSerialPortLib/PeiI2cHdmiDebugSerialPortLib.inf
!endif

[LibraryClasses.IA32.SEC]
  #######################################
  # Edk2 Packages
  #######################################
  DebugLib|MdePkg/Library/BaseDebugLibNull/BaseDebugLibNull.inf
  SerialPortLib|MdePkg/Library/BaseSerialPortLibNull/BaseSerialPortLibNull.inf

  #######################################
  # Platform Package
  #######################################
  TestPointCheckLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointCheckLib/SecTestPointCheckLib.inf
  SiliconPolicyUpdateLib|$(PLATFORM_PACKAGE)/PlatformInit/Library/SiliconPolicyUpdateLibNull/SiliconPolicyUpdateLibNull.inf

  #######################################
  # Board-specific
  #######################################
  SecBoardInitLib|$(PLATFORM_BOARD_PACKAGE)/Library/SecBoardInitLib/SecBoardInitLib.inf

[LibraryClasses.common.PEIM]
  #######################################
  # Edk2 Packages
  #######################################
!if $(TARGET) == DEBUG
  DebugLib|MdeModulePkg/Library/PeiDxeDebugLibReportStatusCode/PeiDxeDebugLibReportStatusCode.inf
!endif
  SerialPortLib|MdePkg/Library/BaseSerialPortLibNull/BaseSerialPortLibNull.inf

  #######################################
  # Silicon Package
  #######################################
  ReportCpuHobLib|IntelSiliconPkg/Library/ReportCpuHobLib/ReportCpuHobLib.inf
  SmmAccessLib|IntelSiliconPkg/Feature/SmmAccess/Library/PeiSmmAccessLibSmramc/PeiSmmAccessLib.inf

  #######################################
  # Platform Package
  #######################################
  BoardInitLib|$(PLATFORM_PACKAGE)/PlatformInit/Library/MultiBoardInitSupportLib/PeiMultiBoardInitSupportLib.inf
  FspWrapperPlatformLib|$(PLATFORM_PACKAGE)/FspWrapper/Library/PeiFspWrapperPlatformLib/PeiFspWrapperPlatformLib.inf
  MultiBoardInitSupportLib|$(PLATFORM_PACKAGE)/PlatformInit/Library/MultiBoardInitSupportLib/PeiMultiBoardInitSupportLib.inf
  TestPointLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointLib/PeiTestPointLib.inf
!if $(TARGET) == DEBUG
  TestPointCheckLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointCheckLib/PeiTestPointCheckLib.inf
!endif
  SetCacheMtrrLib|$(PLATFORM_PACKAGE)/Library/SetCacheMtrrLib/SetCacheMtrrLibNull.inf

  #######################################
  # Board Package
  #######################################
  # Thunderbolt
!if gKabylakeOpenBoardPkgTokenSpaceGuid.PcdTbtEnable == TRUE
  PeiDTbtInitLib|$(PLATFORM_BOARD_PACKAGE)/Features/Tbt/Library/Private/PeiDTbtInitLib/PeiDTbtInitLib.inf
  PeiTbtPolicyLib|$(PLATFORM_BOARD_PACKAGE)/Features/Tbt/Library/PeiTbtPolicyLib/PeiTbtPolicyLib.inf
!endif

[LibraryClasses.common.DXE_CORE]
!if $(TARGET) == DEBUG
  DebugLib|MdeModulePkg/Library/PeiDxeDebugLibReportStatusCode/PeiDxeDebugLibReportStatusCode.inf
!endif

[LibraryClasses.common.DXE_DRIVER]
  #######################################
  # Edk2 Packages
  #######################################
!if $(TARGET) == DEBUG
  DebugLib|MdeModulePkg/Library/PeiDxeDebugLibReportStatusCode/PeiDxeDebugLibReportStatusCode.inf
!endif

  #######################################
  # Silicon Initialization Package
  #######################################
  SiliconPolicyInitLib|$(PLATFORM_SI_PACKAGE)/Library/DxeSiliconPolicyInitLib/DxeSiliconPolicyInitLib.inf

  #######################################
  # Platform Package
  #######################################
  BoardAcpiTableLib|$(PLATFORM_PACKAGE)/Acpi/Library/MultiBoardAcpiSupportLib/DxeMultiBoardAcpiSupportLib.inf
  BoardInitLib|$(PLATFORM_PACKAGE)/PlatformInit/Library/MultiBoardInitSupportLib/DxeMultiBoardInitSupportLib.inf
  FspWrapperPlatformLib|$(PLATFORM_PACKAGE)/FspWrapper/Library/DxeFspWrapperPlatformLib/DxeFspWrapperPlatformLib.inf
  MultiBoardAcpiSupportLib|$(PLATFORM_PACKAGE)/Acpi/Library/MultiBoardAcpiSupportLib/DxeMultiBoardAcpiSupportLib.inf
  MultiBoardInitSupportLib|$(PLATFORM_PACKAGE)/PlatformInit/Library/MultiBoardInitSupportLib/DxeMultiBoardInitSupportLib.inf
  TestPointLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointLib/DxeTestPointLib.inf

!if $(TARGET) == DEBUG
  TestPointCheckLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointCheckLib/DxeTestPointCheckLib.inf
!endif

  #######################################
  # Board Package
  #######################################
  BoardBdsHookLib|BoardModulePkg/Library/BoardBdsHookLib/BoardBdsHookLib.inf
  BoardBootManagerLib|BoardModulePkg/Library/BoardBootManagerLib/BoardBootManagerLib.inf

  #######################################
  # Board-specific
  #######################################
  SiliconPolicyUpdateLib|$(PROJECT)/Policy/Library/DxeSiliconPolicyUpdateLib/DxeSiliconPolicyUpdateLib.inf

[LibraryClasses.X64.DXE_RUNTIME_DRIVER]
  #######################################
  # Edk2 Packages
  #######################################
!if $(TARGET) == DEBUG
  DebugLib|MdeModulePkg/Library/PeiDxeDebugLibReportStatusCode/PeiDxeDebugLibReportStatusCode.inf
!endif

  #######################################
  # Silicon Initialization Package
  #######################################
  ResetSystemLib|$(PLATFORM_SI_PACKAGE)/Pch/Library/DxeRuntimeResetSystemLib/DxeRuntimeResetSystemLib.inf

[LibraryClasses.common.SMM_CORE]
!if $(TARGET) == DEBUG && gKabylakeOpenBoardPkgTokenSpaceGuid.PcdI2cHdmiDebugPortEnable == TRUE
  DebugLib|MdePkg/Library/BaseDebugLibSerialPort/BaseDebugLibSerialPort.inf
  SerialPortLib|$(PLATFORM_BOARD_PACKAGE)/Library/I2cHdmiDebugSerialPortLib/SmmI2cHdmiDebugSerialPortLib.inf
!endif

[LibraryClasses.X64.DXE_SMM_DRIVER]
  #######################################
  # Silicon Initialization Package
  #######################################
  SpiFlashCommonLib|IntelSiliconPkg/Library/SmmSpiFlashCommonLib/SmmSpiFlashCommonLib.inf

  #######################################
  # Platform Package
  #######################################
  BoardAcpiEnableLib|$(PLATFORM_PACKAGE)/Acpi/Library/MultiBoardAcpiSupportLib/SmmMultiBoardAcpiSupportLib.inf
  MultiBoardAcpiSupportLib|$(PLATFORM_PACKAGE)/Acpi/Library/MultiBoardAcpiSupportLib/SmmMultiBoardAcpiSupportLib.inf
  TestPointLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointLib/SmmTestPointLib.inf
!if $(TARGET) == DEBUG
  TestPointCheckLib|$(PLATFORM_PACKAGE)/Test/Library/TestPointCheckLib/SmmTestPointCheckLib.inf
  DebugLib|MdeModulePkg/Library/PeiDxeDebugLibReportStatusCode/PeiDxeDebugLibReportStatusCode.inf
!endif

#######################################
# PEI Components
#######################################
[Components.$(PEI_ARCH)]
  #######################################
  # Edk2 Packages
  #######################################
  UefiCpuPkg/SecCore/SecCore.inf {
    <LibraryClasses>
      PcdLib|MdePkg/Library/PeiPcdLib/PeiPcdLib.inf
  }

  MdeModulePkg/Universal/StatusCodeHandler/Pei/StatusCodeHandlerPei.inf {
    <LibraryClasses>
      DebugLib|MdePkg/Library/BaseDebugLibNull/BaseDebugLibNull.inf
!if $(TARGET) == DEBUG  && gKabylakeOpenBoardPkgTokenSpaceGuid.PcdI2cHdmiDebugPortEnable == TRUE
      SerialPortLib|$(PLATFORM_BOARD_PACKAGE)/Library/I2cHdmiDebugSerialPortLib/PeiI2cHdmiDebugSerialPortLib.inf
!endif
  }

  IntelFsp2WrapperPkg/FspmWrapperPeim/FspmWrapperPeim.inf {
    <LibraryClasses>
      SiliconPolicyInitLib|$(PLATFORM_SI_PACKAGE)/Library/PeiSiliconPolicyInitLibDependency/PeiPreMemSiliconPolicyInitLibDependency.inf
  }
  IntelFsp2WrapperPkg/FspsWrapperPeim/FspsWrapperPeim.inf {
    <LibraryClasses>
      SiliconPolicyInitLib|$(PLATFORM_SI_PACKAGE)/Library/PeiSiliconPolicyInitLibDependency/PeiPostMemSiliconPolicyInitLibDependency.inf
  }

  #######################################
  # Silicon Initialization Package
  #######################################
  IntelSiliconPkg/Feature/VTd/IntelVTdPmrPei/IntelVTdPmrPei.inf
  IntelSiliconPkg/Feature/VTd/PlatformVTdInfoSamplePei/PlatformVTdInfoSamplePei.inf

  #######################################
  # Platform Package
  #######################################
  $(PLATFORM_PACKAGE)/PlatformInit/ReportFv/ReportFvPei.inf
  $(PLATFORM_PACKAGE)/PlatformInit/PlatformInitPei/PlatformInitPreMem.inf {
    <LibraryClasses>
      !if gKabylakeOpenBoardPkgTokenSpaceGuid.PcdMultiBoardSupport == FALSE
        BoardInitLib|$(PROJECT)/Library/BoardInitLib/PeiBoardInitPreMemLib.inf
      !else
        NULL|$(PROJECT)/Library/BoardInitLib/PeiMultiBoardInitPreMemLib.inf
      !endif
  }

  $(PLATFORM_PACKAGE)/PlatformInit/PlatformInitPei/PlatformInitPostMem.inf {
    <LibraryClasses>
      !if gKabylakeOpenBoardPkgTokenSpaceGuid.PcdMultiBoardSupport == FALSE
        BoardInitLib|$(PROJECT)/Library/BoardInitLib/PeiBoardInitPostMemLib.inf
      !else
        NULL|$(PROJECT)/Library/BoardInitLib/PeiMultiBoardInitPostMemLib.inf
      !endif
  }

  $(PLATFORM_PACKAGE)/PlatformInit/SiliconPolicyPei/SiliconPolicyPeiPreMem.inf {
    <LibraryClasses>
    #
    # Hook a library constructor to update some policy fields when policy is installed.
    #
    NULL|$(PLATFORM_BOARD_PACKAGE)/FspWrapper/Library/PeiSiliconPolicyNotifyLib/PeiPreMemSiliconPolicyNotifyLib.inf
  }
  $(PLATFORM_PACKAGE)/PlatformInit/SiliconPolicyPei/SiliconPolicyPeiPostMem.inf

!if gMinPlatformPkgTokenSpaceGuid.PcdTpm2Enable == TRUE
  $(PLATFORM_PACKAGE)/Tcg/Tcg2PlatformPei/Tcg2PlatformPei.inf
!endif

  #######################################
  # Board Package
  #######################################
  # Thunderbolt
!if gKabylakeOpenBoardPkgTokenSpaceGuid.PcdTbtEnable == TRUE
  $(PLATFORM_BOARD_PACKAGE)/Features/Tbt/TbtInit/Pei/PeiTbtInit.inf
!endif
  $(PLATFORM_BOARD_PACKAGE)/BiosInfo/BiosInfo.inf

#######################################
# DXE Components
#######################################
[Components.$(DXE_ARCH)]
  #######################################
  # Edk2 Packages
  #######################################
  !if $(TARGET) == DEBUG
  MdeModulePkg/Universal/StatusCodeHandler/RuntimeDxe/StatusCodeHandlerRuntimeDxe.inf {
    <LibraryClasses>
      DebugLib|MdePkg/Library/BaseDebugLibNull/BaseDebugLibNull.inf
      !if gKabylakeOpenBoardPkgTokenSpaceGuid.PcdI2cHdmiDebugPortEnable == TRUE
        SerialPortLib|$(PLATFORM_BOARD_PACKAGE)/Library/I2cHdmiDebugSerialPortLib/DxeI2cHdmiDebugSerialPortLib.inf
      !endif
  }
    MdeModulePkg/Universal/ReportStatusCodeRouter/Smm/ReportStatusCodeRouterSmm.inf {
      <LibraryClasses>
        DebugLib|MdePkg/Library/BaseDebugLibNull/BaseDebugLibNull.inf
    }
  MdeModulePkg/Universal/StatusCodeHandler/Smm/StatusCodeHandlerSmm.inf {
      <LibraryClasses>
        DebugLib|MdePkg/Library/BaseDebugLibNull/BaseDebugLibNull.inf
        !if gKabylakeOpenBoardPkgTokenSpaceGuid.PcdI2cHdmiDebugPortEnable == TRUE
          SerialPortLib|$(PLATFORM_BOARD_PACKAGE)/Library/I2cHdmiDebugSerialPortLib/SmmI2cHdmiDebugSerialPortLib.inf
        !endif
    }
  !endif
  IntelFsp2WrapperPkg/FspWrapperNotifyDxe/FspWrapperNotifyDxe.inf
  MdeModulePkg/Bus/Ata/AtaAtapiPassThru/AtaAtapiPassThru.inf
  MdeModulePkg/Bus/Ata/AtaBusDxe/AtaBusDxe.inf
  MdeModulePkg/Bus/Pci/NvmExpressDxe/NvmExpressDxe.inf
  MdeModulePkg/Bus/Pci/PciHostBridgeDxe/PciHostBridgeDxe.inf
  MdeModulePkg/Bus/Pci/SataControllerDxe/SataControllerDxe.inf
  MdeModulePkg/Universal/Console/GraphicsOutputDxe/GraphicsOutputDxe.inf
  MdeModulePkg/Bus/Isa/Ps2KeyboardDxe/Ps2KeyboardDxe.inf
  MdeModulePkg/Universal/BdsDxe/BdsDxe.inf {
    <LibraryClasses>
      NULL|BoardModulePkg/Library/BdsPs2KbcLib/BdsPs2KbcLib.inf
!if gMinPlatformPkgTokenSpaceGuid.PcdSerialTerminalEnable == TRUE
      NULL|MinPlatformPkg/Library/SerialPortTerminalLib/SerialPortTerminalLib.inf
!endif
  }
  UefiCpuPkg/CpuDxe/CpuDxe.inf

  ShellPkg/Application/Shell/Shell.inf {
   <PcdsFixedAtBuild>
     gEfiShellPkgTokenSpaceGuid.PcdShellLibAutoInitialize|FALSE
   <LibraryClasses>
     NULL|ShellPkg/Library/UefiShellLevel2CommandsLib/UefiShellLevel2CommandsLib.inf
     NULL|ShellPkg/Library/UefiShellLevel1CommandsLib/UefiShellLevel1CommandsLib.inf
     NULL|ShellPkg/Library/UefiShellLevel3CommandsLib/UefiShellLevel3CommandsLib.inf
     NULL|ShellPkg/Library/UefiShellDriver1CommandsLib/UefiShellDriver1CommandsLib.inf
     NULL|ShellPkg/Library/UefiShellInstall1CommandsLib/UefiShellInstall1CommandsLib.inf
     NULL|ShellPkg/Library/UefiShellDebug1CommandsLib/UefiShellDebug1CommandsLib.inf
     NULL|ShellPkg/Library/UefiShellNetwork1CommandsLib/UefiShellNetwork1CommandsLib.inf
     NULL|ShellPkg/Library/UefiShellNetwork2CommandsLib/UefiShellNetwork2CommandsLib.inf
     ShellCommandLib|ShellPkg/Library/UefiShellCommandLib/UefiShellCommandLib.inf
     HandleParsingLib|ShellPkg/Library/UefiHandleParsingLib/UefiHandleParsingLib.inf
     BcfgCommandLib|ShellPkg/Library/UefiShellBcfgCommandLib/UefiShellBcfgCommandLib.inf
     ShellCEntryLib|ShellPkg/Library/UefiShellCEntryLib/UefiShellCEntryLib.inf
     ShellLib|ShellPkg/Library/UefiShellLib/UefiShellLib.inf
  }

!if gMinPlatformPkgTokenSpaceGuid.PcdBootToShellOnly == FALSE
  UefiCpuPkg/PiSmmCpuDxeSmm/PiSmmCpuDxeSmm.inf {
    <PcdsPatchableInModule>
      gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x80080046
    <LibraryClasses>
      !if $(TARGET) == DEBUG
        DebugLib|MdePkg/Library/BaseDebugLibSerialPort/BaseDebugLibSerialPort.inf
        !if gKabylakeOpenBoardPkgTokenSpaceGuid.PcdI2cHdmiDebugPortEnable == TRUE
          SerialPortLib|$(PLATFORM_BOARD_PACKAGE)/Library/I2cHdmiDebugSerialPortLib/SmmI2cHdmiDebugSerialPortLib.inf
        !endif
      !endif
  }
!endif
!if gKabylakeOpenBoardPkgTokenSpaceGuid.PcdI2cHdmiDebugPortSerialTerminalEnable == TRUE
  MdeModulePkg/Universal/SerialDxe/SerialDxe.inf {
    <LibraryClasses>
      DebugLib|MdePkg/Library/BaseDebugLibNull/BaseDebugLibNull.inf
      SerialPortLib|$(PLATFORM_BOARD_PACKAGE)/Library/I2cHdmiDebugSerialPortLib/DxeI2cHdmiDebugSerialPortLib.inf
  }
!endif

  #######################################
  # Silicon Initialization Package
  #######################################
  IntelSiliconPkg/Feature/VTd/IntelVTdDxe/IntelVTdDxe.inf
  $(PLATFORM_SI_BIN_PACKAGE)/Microcode/MicrocodeUpdates.inf

!if gMinPlatformPkgTokenSpaceGuid.PcdBootToShellOnly == FALSE
  IntelSiliconPkg/Feature/Flash/SpiFvbService/SpiFvbServiceSmm.inf
!endif

  #######################################
  # Platform Package
  #######################################
  $(PLATFORM_PACKAGE)/FspWrapper/SaveMemoryConfig/SaveMemoryConfig.inf
  $(PLATFORM_PACKAGE)/Hsti/HstiIbvPlatformDxe/HstiIbvPlatformDxe.inf
  $(PLATFORM_PACKAGE)/PlatformInit/PlatformInitDxe/PlatformInitDxe.inf
  $(PLATFORM_PACKAGE)/PlatformInit/SiliconPolicyDxe/SiliconPolicyDxe.inf
  $(PLATFORM_PACKAGE)/Test/TestPointDumpApp/TestPointDumpApp.inf
  $(PLATFORM_PACKAGE)/Test/TestPointStubDxe/TestPointStubDxe.inf

!if gMinPlatformPkgTokenSpaceGuid.PcdTpm2Enable == TRUE
  $(PLATFORM_PACKAGE)/Tcg/Tcg2PlatformDxe/Tcg2PlatformDxe.inf
!endif

!if gMinPlatformPkgTokenSpaceGuid.PcdBootToShellOnly == FALSE

  $(PLATFORM_PACKAGE)/PlatformInit/PlatformInitSmm/PlatformInitSmm.inf

  $(PLATFORM_PACKAGE)/Acpi/AcpiSmm/AcpiSmm.inf {
    <LibraryClasses>
      !if gKabylakeOpenBoardPkgTokenSpaceGuid.PcdMultiBoardSupport == FALSE
        BoardAcpiEnableLib|$(PROJECT)/Library/BoardAcpiLib/SmmBoardAcpiEnableLib.inf
      !else
        NULL|$(PROJECT)/Library/BoardAcpiLib/SmmMultiBoardAcpiSupportLib.inf
      !endif
  }

  $(PLATFORM_PACKAGE)/Acpi/AcpiTables/AcpiPlatform.inf {
    <LibraryClasses>
      !if gKabylakeOpenBoardPkgTokenSpaceGuid.PcdMultiBoardSupport == FALSE
        BoardAcpiTableLib|$(PROJECT)/Library/BoardAcpiLib/DxeBoardAcpiTableLib.inf
      !else
        NULL|$(PROJECT)/Library/BoardAcpiLib/DxeMultiBoardAcpiSupportLib.inf
      !endif
  }

!if gS3FeaturePkgTokenSpaceGuid.PcdS3FeatureEnable == TRUE
  MdeModulePkg/Universal/Acpi/BootScriptExecutorDxe/BootScriptExecutorDxe.inf {
    <LibraryClasses>
      # On S3 resume, RSC is in end-of-BS state
      # - Moreover: Libraries cannot effectively use some end-of-BS events
      DebugLib|MdePkg/Library/BaseDebugLibSerialPort/BaseDebugLibSerialPort.inf
      SerialPortLib|MdePkg/Library/BaseSerialPortLibNull/BaseSerialPortLibNull.inf
      # Reverse-ranked priority list
!if gKabylakeOpenBoardPkgTokenSpaceGuid.PcdI2cHdmiDebugPortEnable == TRUE
      SerialPortLib|$(PLATFORM_BOARD_PACKAGE)/Library/I2cHdmiDebugSerialPortLib/BootScriptExecutorDxeI2cHdmiDebugSerialPortLib.inf
!endif
  }
!endif

!endif

  #######################################
  # Board Package
  #######################################
  # Thunderbolt
!if gKabylakeOpenBoardPkgTokenSpaceGuid.PcdTbtEnable == TRUE
  $(PLATFORM_BOARD_PACKAGE)/Features/Tbt/TbtInit/Smm/TbtSmm.inf
  $(PLATFORM_BOARD_PACKAGE)/Features/Tbt/TbtInit/Dxe/TbtDxe.inf
  $(PLATFORM_BOARD_PACKAGE)/Features/PciHotPlug/PciHotPlug.inf
!endif

!if gMinPlatformPkgTokenSpaceGuid.PcdBootToShellOnly == FALSE
  $(PLATFORM_BOARD_PACKAGE)/Acpi/BoardAcpiDxe/BoardAcpiDxe.inf {
    <LibraryClasses>
      !if gKabylakeOpenBoardPkgTokenSpaceGuid.PcdMultiBoardSupport == FALSE
        BoardAcpiTableLib|$(PROJECT)/Library/BoardAcpiLib/DxeBoardAcpiTableLib.inf
      !else
        NULL|$(PROJECT)/Library/BoardAcpiLib/DxeMultiBoardAcpiSupportLib.inf
      !endif
  }
!endif
  BoardModulePkg/LegacySioDxe/LegacySioDxe.inf
  BoardModulePkg/BoardBdsHookDxe/BoardBdsHookDxe.inf
