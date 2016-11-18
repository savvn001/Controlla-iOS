//
//  midibus_enums.h
//  MidiBus
//
//  Created by Nic Grant on 28/05/2013.
//  Copyright (c) 2013 Soft Audio Pty Ltd. All rights reserved.
//

#ifndef MidiBus_midibus_enums_h
#define MidiBus_midibus_enums_h

#include "TargetConditionals.h"

// status enum
typedef enum enum_MidiBusStatus
{
    eMidiBusStatusOK = 0,                         // no error
    eMidiBusStatusInvalidAppName = 1,             // bad or empty appname passed
    eMidiBusStatusVirtSetupFail = 2 ,             // failed to create virtual port(s) (background mode?)
    eMidiBusStatusInvalidMessage = 3,             // message invalid (length == 0)
    eMidiBusStatusSysexStarted = 4,               // sysex receive has started
    eMidiBusStatusSysexEnded = 5,                 // sysex receive has completed
    eMidiBusStatusSysexFailed = 6,                // sysex receive failed
    eMidiBusStatusSysexSent = 7,                  // sysex send has completed
    eMidiBusStatusSetupFailed = 8                 // failed to setup MIDI transport
} eMidiBusStatus;

// modes of MIDI interface
typedef enum enum_MidiBusInterfaceMode
{
    eMidiBusInterfaceModeInput = 0,              // interface is MIDI source only
    eMidiBusInterfaceModeOutput = 1,             // interface is MIDI destination only
    eMidiBusInterfaceModeDual = 2,               // interface is both source and destination
   
    // for backwards compatibility
    eMidiBusInterfaceModeSource = 0,             // pure input
    eMidiBusInterfaceModeDestination = 1,        // pure output
} eMidiBusInterfaceMode;

// types of MIDI interface
typedef enum enum_MidiBusInterfaceType
{
    eMidiBusInterfaceTypePhysical = 0,             // interface is physical
    eMidiBusInterfaceTypeNetwork = 1,              // interface is network
    eMidiBusInterfaceTypeVirtual = 2               // interface is virtual
} eMidiBusInterfaceType;

// virtual midi mode (none, input, output, dual) - set by client app
typedef enum enum_MidiBusVirtualMode
{
    eMidiBusVirtualModeNone = 0,                // app has no virtual MIDI ports
    eMidiBusVirtualModeInput = 1,               // app only receives (eg. sound module receives MIDI)
    eMidiBusVirtualModeOutput = 2,              // app only sends (eg. controller sends MIDI)
    eMidiBusVirtualModeDual = 3                 // app sends and receives (eg. filter)
} eMidiBusVirtualMode;

// MIDI message types
typedef enum enum_MidiBusMessageType
{
	eMidiBusTypeNone = 0,
	eMidiBusNoteOffType = 1,
	eMidiBusNoteOnType = 2,
	eMidiBusPolyKeyPressureType = 3,
	eMidiBusControllerType = 4,
	eMidiBusProgramChangeType = 5,
	eMidiBusChannelPressureType = 6,
	eMidiBusPitchBendType = 7,
	eMidiBusMTCQuarterFrameType = 8,
	eMidiBusMTCFullFrameType = 9,
	eMidiBusSongPositionPointerType = 10,
	eMidiBusSongSelectType = 11,
	eMidiBusTuneRequestType = 12,
	eMidiBusClockType = 13,
	eMidiBusUndefined = 14,
	eMidiBusStartType = 15,
	eMidiBusContinueType = 16,
	eMidiBusStopType = 17,
	eMidiBusActiveSenseType = 18,
	eMidiBusResetType = 19,
	eMidiBusSysexStartType = 20,
	eMidiBusSysexEndType = 21,
	eMidiBusSysexRealTimeType = 22,
	eMidiBusSysexNonRealTimeType = 23
} eMidiBusMessageType;

// MIDI message classes
typedef enum enum_MidiBusMessageClass
{
	eMidiBusClassNone = 0,
	eMidiBusNoteClass = 1,
	eMidiBusAftertouchClass = 2,
	eMidiBusControllerClass = 3,
	eMidiBusProgramClass = 4,
	eMidiBusSysexClass = 5,
	eMidiBusTimesongClass = 6
} eMidiBusMessageClass;


#endif
