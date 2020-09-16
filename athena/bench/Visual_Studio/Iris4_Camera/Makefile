TARGET	= Iris4_Camera

CFLAGS   = -I$(MILDIR)/include -I./include -g -Werror $(USER_CFLAGS)
CXXFLAGS = $(CFLAGS) -std=c++11
LDFLAGS  = -L$(MILDIR)/lib -lmil -lmilim -lpthread -lstdc++
.PHONY   = all clean

SRC_MAIN  = Iris4_Camera.cpp
SRC_SOURCES = source/osfunctions.cpp \
              source/flashupdate.cpp \
              source/I2C.cpp \
              source/MilLayer.cpp \
			  source/mtxservmanager.cpp \
			  source/Pcie.cpp \
			  source/Random.cpp \
			  source/SystemTree.cpp \
			  source/XGS_Ctrl.cpp \
			  source/XGS_Data.cpp \
			  source/XGS5K.cpp \
              source/XGS12K.cpp \
			  source/XGS16K.cpp \
			  source/XGSxK.cpp
SRC_TESTS = tests/test_0000_Continu.cpp \
            tests/test_0001_SWtrig.cpp \
			tests/test_0002_Continu_2xROI.cpp \
			tests/test_0003_HW_Timer.cpp \
			tests/test_0004_Continu_FPS.cpp \
			tests/test_0005_SWtrig_Random.cpp \
			tests/test_0006_SWtrig_BlackCorr.cpp \
			tests/test_0007_Continu_DPC.cpp \
			tests/test_0009_Optics.cpp

all: $(TARGET)

clean:
	-rm -f $(TARGET)

$(TARGET) : $(SRC_MAIN) $(SRC_SOURCES) $(SRC_TESTS)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS) 