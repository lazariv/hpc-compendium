# Miscellaneous

## Check Assembler Code

If a binary `a.out` was built to include symbolic information (option
"-g") one can have a look at a commented disassembly with

    objdump -dS a.out 

to see something like:

       do {
            checksum += d.D.ACC(idx).i[0] * d.D.ACC(idx).i[1];
     8049940:   89 d9                   mov    %ebx,%ecx
     8049942:   2b 8d 08 fa ff ff       sub    -0x5f8(%ebp),%ecx
     8049948:   8b 55 c4                mov    -0x3c(%ebp),%edx
     804994b:   2b 95 0c fa ff ff       sub    -0x5f4(%ebp),%edx
     8049951:   8b 45 c8                mov    -0x38(%ebp),%eax
     8049954:   2b 85 10 fa ff ff       sub    -0x5f0(%ebp),%eax
     804995a:   0f af 85 78 fd ff ff    imul   -0x288(%ebp),%eax
     8049961:   01 c2                   add    %eax,%edx
     8049963:   0f af 95 74 fd ff ff    imul   -0x28c(%ebp),%edx
     804996a:   01 d1                   add    %edx,%ecx
     804996c:   8d 0c 49                lea    (%ecx,%ecx,2),%ecx
     804996f:   c1 e1 03                shl    $0x3,%ecx
     8049972:   03 8d b8 fd ff ff       add    -0x248(%ebp),%ecx
     8049978:   dd 01                   fldl   (%ecx)
     804997a:   dd 41 08                fldl   0x8(%ecx)
     804997d:   d9 c1                   fld    %st(1)
     804997f:   d8 c9                   fmul   %st(1),%st
     8049981:   dc 85 b8 f9 ff ff       faddl  -0x648(%ebp)
            checksum += d.D.ACC(idx).i[2] * d.D.ACC(idx).i[0];
     8049987:   dd 41 10                fldl   0x10(%ecx)
     804998a:   dc cb                   fmul   %st,%st(3)
     804998c:   d9 cb                   fxch   %st(3)
     804998e:   de c1                   faddp  %st,%st(1)
     8049990:   d9 c9                   fxch   %st(1)
            checksum -= d.D.ACC(idx).i[1] * d.D.ACC(idx).i[2];
     8049992:   de ca                   fmulp  %st,%st(2)
     8049994:   de e1                   fsubp  %st,%st(1)
     8049996:   dd 9d b8 f9 ff ff       fstpl  -0x648(%ebp)
     }

## I/O from/to binary files

## Compilation Problem Isolator

`icpi`

-- Main.mark - 2009-12-16
