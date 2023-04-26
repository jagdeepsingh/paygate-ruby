# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Paygate::Aes do
  # rubocop:disable RSpec/IndexedLet
  let(:key128) { '0123456789abcdef' }
  let(:key192) { '0123456789abcdef012345' }
  let(:key256) { '0123456789abcdef0123456789abcdef' }
  # rubocop:enable RSpec/IndexedLet

  describe '.cipher' do
    context 'when encrypting with 128-bit key' do
      it 'encrypts the input correctly' do
        input = '0123456789abcdef'
        expected_output = '72727e881edcfd0100a718687909b565'
        key_schedule = described_class.key_expansion(key128.bytes)
        output = described_class.cipher(input.bytes, key_schedule)

        expect(output.pack('c*').unpack1('H*')).to eq(expected_output)
      end
    end

    context 'when encrypting with 192-bit key' do
      it 'encrypts the input correctly' do
        input = '0123456789abcdef01234567'
        expected_output = '943cb7b4f5ec4afcbd2973b72ba25e4a'
        key_schedule = described_class.key_expansion(key192.bytes)
        output = described_class.cipher(input.bytes, key_schedule)

        expect(output.pack('c*').unpack1('H*')).to eq(expected_output)
      end
    end

    context 'when encrypting with 256-bit key' do
      it 'encrypts the input correctly' do
        input = '0123456789abcdef0123456789abcdef'
        expected_output = 'f83c9a60dc0cdb98219f79d6d5db1635'
        key_schedule = described_class.key_expansion(key256.bytes)
        output = described_class.cipher(input.bytes, key_schedule)

        expect(output.pack('c*').unpack1('H*')).to eq(expected_output)
      end
    end
  end

  describe '.key_expansion' do
    context 'when expanding a 128-bit key' do
      let(:expected_schedule) do
        [
          [48, 49, 50, 51],
          [52, 53, 54, 55],
          [56, 57, 97, 98],
          [99, 100, 101, 102],
          [114, 124, 1, 200],
          [70, 73, 55, 255],
          [126, 112, 86, 157],
          [29, 20, 51, 251],
          [138, 191, 14, 108],
          [204, 246, 57, 147],
          [178, 134, 111, 14],
          [175, 146, 92, 245],
          [193, 245, 232, 21],
          [13, 3, 209, 134],
          [191, 133, 190, 136],
          [16, 23, 226, 125],
          [57, 109, 23, 223],
          [52, 110, 198, 89],
          [139, 235, 120, 209],
          [155, 252, 154, 172],
          [153, 213, 134, 203],
          [173, 187, 64, 146],
          [38, 80, 56, 67],
          [189, 172, 162, 239],
          [40, 239, 89, 177],
          [133, 84, 25, 35],
          [163, 4, 33, 96],
          [30, 168, 131, 143],
          [170, 3, 42, 195],
          [47, 87, 51, 224],
          [140, 83, 18, 128],
          [146, 251, 145, 15],
          [37, 130, 92, 140],
          [10, 213, 111, 108],
          [134, 134, 125, 236],
          [20, 125, 236, 227],
          [193, 76, 77, 118],
          [203, 153, 34, 26],
          [77, 31, 95, 246],
          [89, 98, 179, 21],
          [93, 33, 20, 189],
          [150, 184, 54, 167],
          [219, 167, 105, 81],
          [130, 197, 218, 68]
        ]
      end

      it 'returns the expected key schedule' do
        key = key128.bytes
        schedule = described_class.key_expansion(key)
        expect(schedule).to eq(expected_schedule)
      end
    end

    context 'when expanding a 192-bit key' do
      let(:expected_schedule) do
        [
          [48, 49, 50, 51],
          [52, 53, 54, 55],
          [56, 57, 97, 98],
          [99, 100, 101, 102],
          [48, 49, 50, 51],
          [246, 18, 241, 55],
          [194, 39, 199, 0],
          [250, 30, 166, 98],
          [153, 122, 195, 4],
          [169, 75, 241, 55],
          [71, 179, 107, 228],
          [133, 148, 172, 228],
          [127, 138, 10, 134],
          [230, 240, 201, 130],
          [79, 187, 56, 181],
          [169, 180, 190, 96],
          [44, 32, 18, 132],
          [83, 170, 24, 2],
          [181, 90, 209, 128],
          [250, 225, 233, 53],
          [89, 170, 40, 77],
          [117, 138, 58, 201],
          [38, 32, 34, 203],
          [147, 122, 243, 75],
          [105, 155, 26, 126],
          [93, 8, 219, 180],
          [40, 130, 225, 125],
          [14, 162, 195, 182],
          [157, 216, 48, 253],
          [244, 67, 42, 131],
          [103, 237, 55, 11],
          [79, 111, 214, 118],
          [65, 205, 21, 192],
          [220, 21, 37, 61],
          [40, 86, 15, 190],
          [150, 155, 153, 63],
          [217, 244, 79, 73],
          [152, 57, 90, 137],
          [68, 44, 127, 180],
          [108, 122, 112, 10],
          [204, 202, 254, 111],
          [21, 62, 177, 38],
          [141, 7, 235, 175],
          [201, 43, 148, 27],
          [165, 81, 228, 17],
          [6, 163, 124, 105],
          [19, 157, 205, 79],
          [158, 154, 38, 224]
        ]
      end

      it 'returns the expected key schedule' do
        key = key192.bytes
        schedule = described_class.key_expansion(key)
        expect(schedule).to eq(expected_schedule)
      end
    end

    context 'when expanding a 256-bit key' do
      let(:expected_schedule) do
        [
          [48, 49, 50, 51],
          [52, 53, 54, 55],
          [56, 57, 97, 98],
          [99, 100, 101, 102],
          [48, 49, 50, 51],
          [52, 53, 54, 55],
          [56, 57, 97, 98],
          [99, 100, 101, 102],
          [114, 124, 1, 200],
          [70, 73, 55, 255],
          [126, 112, 86, 157],
          [29, 20, 51, 251],
          [148, 203, 241, 60],
          [160, 254, 199, 11],
          [152, 199, 166, 105],
          [251, 163, 195, 15],
          [122, 82, 119, 199],
          [60, 27, 64, 56],
          [66, 107, 22, 165],
          [95, 127, 37, 94],
          [91, 25, 206, 100],
          [251, 231, 9, 111],
          [99, 32, 175, 6],
          [152, 131, 108, 9],
          [146, 2, 118, 129],
          [174, 25, 54, 185],
          [236, 114, 32, 28],
          [179, 13, 5, 66],
          [54, 206, 165, 72],
          [205, 41, 172, 39],
          [174, 9, 3, 33],
          [54, 138, 111, 40],
          [228, 170, 66, 132],
          [74, 179, 116, 61],
          [166, 193, 84, 33],
          [21, 204, 81, 99],
          [111, 133, 116, 179],
          [162, 172, 216, 148],
          [12, 165, 219, 181],
          [58, 47, 180, 157],
          [225, 39, 28, 4],
          [171, 148, 104, 57],
          [13, 85, 60, 24],
          [24, 153, 109, 123],
          [194, 107, 72, 146],
          [96, 199, 144, 6],
          [108, 98, 75, 179],
          [86, 77, 255, 46],
          [34, 49, 45, 181],
          [137, 165, 69, 140],
          [132, 240, 121, 148],
          [156, 105, 20, 239],
          [28, 146, 178, 77],
          [124, 85, 34, 75],
          [16, 55, 105, 248],
          [70, 122, 150, 214],
          [184, 161, 219, 239],
          [49, 4, 158, 99],
          [181, 244, 231, 247],
          [41, 157, 243, 24]
        ]
      end

      it 'returns the expected key schedule' do
        key = key256.bytes
        schedule = described_class.key_expansion(key)
        expect(schedule).to eq(expected_schedule)
      end
    end
  end
end
