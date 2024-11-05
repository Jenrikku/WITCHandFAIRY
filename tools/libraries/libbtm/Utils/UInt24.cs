namespace LibBTM.Utils;

internal struct UInt24
{
    public byte B1;
    public byte B2;
    public byte B3;

    public UInt24() { }

    public unsafe UInt24(int value)
        : this((uint)value) { }

    public unsafe UInt24(uint value)
    {
        byte* ptr = (byte*)&value;

        if (!BitConverter.IsLittleEndian)
            ptr++;

        this = *(UInt24*)ptr;
    }

    public unsafe uint ToUInt32()
    {
        Span<byte> result = stackalloc byte[4] { B1, B2, B3, 0 };

        if (!BitConverter.IsLittleEndian)
            result.Reverse();

        fixed (byte* ptr = result)
            return *(uint*)ptr;
    }

    public static bool operator ==(UInt24 uint24, uint uint32) => uint24.ToUInt32() == uint32;

    public static bool operator !=(UInt24 uint24, uint uint32) => uint24.ToUInt32() != uint32;

    public static implicit operator UInt24(uint uint32) => new(uint32);
}
