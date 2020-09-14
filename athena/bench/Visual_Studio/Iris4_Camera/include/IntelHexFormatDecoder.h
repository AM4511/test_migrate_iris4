//==============================================================================
//
// Filename     :  IntelHexFormatDecoder.h
// Owner        :  Matrox Imaging dept.
// Rev          :
// Content      :  Intel HEX firmware file format decoder.
// Compile flag :
//
// COPYRIGHT (c) Matrox Electronic Systems Ltd.
// All Rights Reserved
//==============================================================================

#ifndef __INTEL_HEX_FORMAT_DECODER_H__
#define __INTEL_HEX_FORMAT_DECODER_H__



namespace IntelHex {



   // A HEX record consists of ASCII text separated by line feed of carriage return.
   // Each text line contains hexadecimal characters that encode multiple binary numbers.
   // Each number may represent data, memory addresses or other values.
   // Record structure:
   // 1- Start code, one character an ":"
   // 2- Byte count, two hex digits indicating the number of bytes in the data field.
   // 3- Address, four hex digits representing the 16-bit address.
   // 4- Record type, two hex digits, 00 to 05, defining the meaning of the data field,
   // 5- Data, a sequence of n bytes of data represented by 2n hex digits.
   // 6- Checksum, two hex digit, a computed value that can be used to verify the record has no error.

   // A sample HEX is shown below :
   //
   // : 10008000AF5F67F0602703E0322CFA92007780C361
   // : 1000900089001C6B7EA7CA9200FE10D2AA00477D81
   // : 0B00A00080FA92006F3600C3A00076CB
   // : 00000001FF

   enum class RecordType_t
      {
      Data = 0x00,
      EndOfFile = 0x01,
      ExtendedSegmentAddress = 0x02,
      StartSegmentAddress = 0x03,
      ExtendedLinearAddress = 0x04,
      StartLinearAddress = 0x05,
      Unknown = 0xff
      };

   static uint8_t Asci2HexLut[256] = { 0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,     //   0 -  15
                                       0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,     //  16 -  31
                                       0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,     //  32 -  47
                                       0x0,0x1,0x2,0x3,0x4,0x5,0x6,0x7,0x8,0x9,0x0,0x0,0x0,0x0,0x0,0x0,     //  48 -  63
                                       0x0,0xA,0xB,0xC,0xD,0xE,0xF,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,     //  64 -  79
                                       0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,     //  80 -  95
                                       0x0,0xA,0xB,0xC,0xD,0xE,0xF,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,     //  96 - 111
                                       0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,     // 112 - 127
                                       0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,     // 128 - 143
                                       0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,     // 144 - 159
                                       0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,     // 160 - 175
                                       0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,     // 176 - 191
                                       0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,     // 192 - 207
                                       0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,     // 208 - 225
                                       0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,     // 224 - 239
                                       0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0 };   // 240 - 256

   using ByteArray_t = std::array<uint8_t, 32>;

   struct Record
      {
      Record() : ByteCount(0), Address(0), Type(RecordType_t::Unknown), Checksum(0) { };

      inline
      static bool Parse(std::string& HexData, std::vector<uint8_t>& oData, uint32_t& oBaseAddress);

      inline
      static void StringToBytes(const std::string& Data, ByteArray_t& oBytes);

      static const char StartCode = ':';
      static const uint32_t InvalidAddress = 0xFFFFFFFFUL;
      uint8_t ByteCount;
      uint16_t Address;
      RecordType_t Type;
      uint8_t Checksum;
      };

   inline
   bool Record::Parse(std::string& HexData, std::vector<uint8_t>& oData, uint32_t& oBaseAddress)
      {
      ByteArray_t Bytes;
      const size_t MaxCharsPerLine = Bytes.max_size() * 2 + 1;
      Record lRecord;
      bool EndOfHexRecords = false;
      size_t LastPosition, CurPosition;

      if (HexData.size() > MaxCharsPerLine)
         throw std::runtime_error("Firmware file error. HEX Record too long.");

      if (HexData[0] != Record::StartCode)
         throw std::runtime_error("Firmware file error. Missing start code from HEX record.");

      StringToBytes(HexData, Bytes);

      lRecord.ByteCount = Bytes[0];
      if (lRecord.ByteCount + 6u > Bytes.max_size())
         throw std::runtime_error("Firmware file error. Invalid byte count.");

      lRecord.Address = (Bytes[1] << 8) | Bytes[2];
      lRecord.Type = static_cast<RecordType_t>(Bytes[3]);
      lRecord.Checksum = Bytes[4 + lRecord.ByteCount];

      // Calculate checksum
      uint32_t Sum = 0;
      uint8_t Checksum = 0;
      for (size_t i = 0; i < 4u + lRecord.ByteCount; i++)
         Sum += Bytes[i];

      Checksum = static_cast<uint8_t>(~Sum) + 1;
      if (Checksum != lRecord.Checksum)
         throw std::runtime_error("Firmware file error. Invalid checksum found.");

      switch (lRecord.Type)
         {
         case RecordType_t::Data:
            LastPosition = oData.size();
            CurPosition = oBaseAddress + lRecord.Address + lRecord.ByteCount;
            if (CurPosition > LastPosition)
               oData.insert(oData.end(), (CurPosition - LastPosition), 0xFF);
            for (size_t i = 0; i < lRecord.ByteCount; i++)
               oData[oBaseAddress + lRecord.Address + i] = Bytes[i + 4];
            break;
         case RecordType_t::ExtendedLinearAddress:
            oBaseAddress = ((Bytes[4] << 8) | Bytes[5]) << 16;
            break;
         case RecordType_t::EndOfFile:
            EndOfHexRecords = true;
            break;
         case RecordType_t::ExtendedSegmentAddress:
         case RecordType_t::StartLinearAddress:
         case RecordType_t::StartSegmentAddress:
         case RecordType_t::Unknown:
            throw std::runtime_error("Firmware file error. Unhandled record type found.");
            break;
         }

      return EndOfHexRecords;
      }

   inline
   void Record::StringToBytes(const std::string& Data, ByteArray_t& oBytes)
      {
      for (size_t i = 1, j = 0; i < Data.size(); i += 2, j++)
         oBytes[j] = (Asci2HexLut[Data[i]] << 4) | Asci2HexLut[Data[i + 1]];
      }
   }

class IntelHexFormatDecoder
   {
   public:
      IntelHexFormatDecoder(const std::string& BeginOfHexDataDelimiter) : _BeginOfHexDataDelimiter(BeginOfHexDataDelimiter), _BaseAddress(IntelHex::Record::InvalidAddress) {};

      inline std::vector<uint8_t> Parse(const std::string& File, size_t EpromSize);
      inline uint32_t BaseAddress() const { return _BaseAddress; }

   private:
      inline bool SkipFileHeader(std::ifstream& infile) const;

      const std::string _BeginOfHexDataDelimiter;
      uint32_t _BaseAddress;
   };

inline bool IntelHexFormatDecoder::SkipFileHeader(std::ifstream& infile) const
   {
   bool Success = false;

   std::string line;
   while (!Success && std::getline(infile, line))
      {
      auto found = line.find(_BeginOfHexDataDelimiter);
      if (found != std::string::npos)
         Success = true;
      }

   return Success;
   }

inline std::vector<uint8_t> IntelHexFormatDecoder::Parse(const std::string& File, size_t EpromSize)
   {
   std::ifstream infile(File);
   uint32_t TmpBaseAddress = _BaseAddress;
   if (!infile.is_open())
      {
      std::stringstream ss;
      ss << "Firmware file error. File \"" << File << "\" not found.";
      throw std::runtime_error(ss.str());
      }

   if (!SkipFileHeader(infile))
      throw std::runtime_error("Firmware file error. Invalid file header.");

   std::vector<uint8_t> Data;
   Data.reserve(EpromSize);
   std::string line;
   bool EndOfHexRecords = false;

   while (std::getline(infile, line) && !EndOfHexRecords)
      {
      EndOfHexRecords = IntelHex::Record::Parse(line, Data, TmpBaseAddress);
      if (TmpBaseAddress < _BaseAddress)
         _BaseAddress = TmpBaseAddress;
      }
      
   if (!EndOfHexRecords)
      throw std::runtime_error("Firmware file error. Missing end of file marker.");

   return Data;
   }

#endif
