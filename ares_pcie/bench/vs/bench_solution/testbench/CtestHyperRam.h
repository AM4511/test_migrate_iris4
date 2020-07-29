#pragma once
#include "Ctest.h"
#include "Cares.h"
#include "Crpc2Ctrl.h"
#include "fdk.h"

using namespace std;
class CtestHyperRam :
	public Ctest
{
public:
	// Class cooking
	CtestHyperRam(Cares& ares);
	~CtestHyperRam();

	// Class function member
	u32 run();
	u32 test_single_access();
	u32 clear32(u32 start, u32 stop, u32 clearValue);
	u32 test_ramp_u8(u32 start, u32 stop, u8 initValue, u8 increment);
	u32 test_ramp_u16(u32 start, u32 stop, u16 initValue, u16 increment);
	u32 test_ramp_u32(u32 start, u32 stop, u32 initValue, int32 increment);
	u32 test_ramp_u64(u32 start, u32 stop, u64 initValue, u64 increment);

	u32 test_ramp_u8_turbo(u32 start, u32 stop, u8 initValue, u8 increment);
	u32 test_ramp_u16_turbo(u32 start, u32 stop, u16 initValue, u16 increment);

	u32 software_trigger();

private:
	Cares& m_ares;
	Crpc2Ctrl* m_rpc2Ctrl;

	//CzynqDDR2* m_zynqDDR2;
};

