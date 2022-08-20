;
; Proc‚dure INTR
;
; Inter-action entre assembleur et programme en Turbo Pascal.
;
; Utilisation des 256 vecteurs d'interruption.
;
; Auteur: Pr‚martin Patrick.
; Date:   10-02-1991.
;         16-02-1991.
;
; Forme de la procedure en Pascal (dans unit‚ INTERUPT):
;      PROCEDURE INTR (Num_Int : Integer; Var Regs : Registres);
; avec le type Registres suivant:
;      TYPE REGISTRES = RECORD
;                         CASE Boolean OF
;                           False : (AX, BX, CX, DX, : Integer);
;                           True  : (AL, AH, BL, AH, CL, CH, DL, DH : Byte)
;                         {endcase}
;                       END;
;
code          segment byte public
;
              assume cs : code
;
              public intr
;
intr          proc far
; sauvegarde des registres.
              push bp
              mov bp, sp
              push ax
              push bx
              push cx
              push dx
              push si
              push di
              push ds
              push es
              pushf
; initialisation de la zone … travailler.
              lds si, [bp+6] ; adresse vraie du paramŠtre de type REGISTRES.
; initialisation des registres utilis‚s.
              mov ax, ds:[si]
              mov bx, ds:[si+2]
              mov cx, ds:[si+4]
              mov dx, ds:[si+6]
; appel des interruptions.
intr_0:
              cmp word ptr [bp+10], 0
              jnz intr_1
              int 0
              jmp intr_fin
intr_1:
              cmp word ptr [bp+10], 1
              jnz intr_2
              int 1
              jmp intr_fin
intr_2:
              cmp word ptr [bp+10], 2
              jnz intr_3
              int 2
              jmp intr_fin
intr_3:
              cmp word ptr [bp+10], 3
              jnz intr_4
              int 3
              jmp intr_fin
intr_4:
              cmp word ptr [bp+10], 4
              jnz intr_5
              int 4
              jmp intr_fin
intr_5:
              cmp word ptr [bp+10], 5
              jnz intr_6
              int 5
              jmp intr_fin
intr_6:
              cmp word ptr [bp+10], 6
              jnz intr_7
              int 6
              jmp intr_fin
intr_7:
              cmp word ptr [bp+10], 7
              jnz intr_8
              int 7
              jmp intr_fin
intr_8:
              cmp word ptr [bp+10], 8
              jnz intr_9
              int 8
              jmp intr_fin
intr_9:
              cmp word ptr [bp+10], 9
              jnz intr_10
              int 9
              jmp intr_fin
intr_10:
              cmp word ptr [bp+10], 10
              jnz intr_11
              int 10
              jmp intr_fin
intr_11:
              cmp word ptr [bp+10], 11
              jnz intr_12
              int 11
              jmp intr_fin
intr_12:
              cmp word ptr [bp+10], 12
              jnz intr_13
              int 12
              jmp intr_fin
intr_13:
              cmp word ptr [bp+10], 13
              jnz intr_14
              int 13
              jmp intr_fin
intr_14:
              cmp word ptr [bp+10], 14
              jnz intr_15
              int 14
              jmp intr_fin
intr_15:
              cmp word ptr [bp+10], 15
              jnz intr_16
              int 15
              jmp intr_fin
intr_16:
              cmp word ptr [bp+10], 16
              jnz intr_17
              int 16
              jmp intr_fin
intr_17:
              cmp word ptr [bp+10], 17
              jnz intr_18
              int 17
              jmp intr_fin
intr_18:
              cmp word ptr [bp+10], 18
              jnz intr_19
              int 18
              jmp intr_fin
intr_19:
              cmp word ptr [bp+10], 19
              jnz intr_20
              int 19
              jmp intr_fin
intr_20:
              cmp word ptr [bp+10], 20
              jnz intr_21
              int 20
              jmp intr_fin
intr_21:
              cmp word ptr [bp+10], 21
              jnz intr_22
              int 21
              jmp intr_fin
intr_22:
              cmp word ptr [bp+10], 22
              jnz intr_23
              int 22
              jmp intr_fin
intr_23:
              cmp word ptr [bp+10], 23
              jnz intr_24
              int 23
              jmp intr_fin
intr_24:
              cmp word ptr [bp+10], 24
              jnz intr_25
              int 24
              jmp intr_fin
intr_25:
              cmp word ptr [bp+10], 25
              jnz intr_26
              int 25
              jmp intr_fin
intr_26:
              cmp word ptr [bp+10], 26
              jnz intr_27
              int 26
              jmp intr_fin
intr_27:
              cmp word ptr [bp+10], 27
              jnz intr_28
              int 27
              jmp intr_fin
intr_28:
              cmp word ptr [bp+10], 28
              jnz intr_29
              int 28
              jmp intr_fin
intr_29:
              cmp word ptr [bp+10], 29
              jnz intr_30
              int 29
              jmp intr_fin
intr_30:
              cmp word ptr [bp+10], 30
              jnz intr_31
              int 30
              jmp intr_fin
intr_31:
              cmp word ptr [bp+10], 31
              jnz intr_32
              int 31
              jmp intr_fin
intr_32:
              cmp word ptr [bp+10], 32
              jnz intr_33
              int 32
              jmp intr_fin
intr_33:
              cmp word ptr [bp+10], 33
              jnz intr_34
              int 33
              jmp intr_fin
intr_34:
              cmp word ptr [bp+10], 34
              jnz intr_35
              int 34
              jmp intr_fin
intr_35:
              cmp word ptr [bp+10], 35
              jnz intr_36
              int 35
              jmp intr_fin
intr_36:
              cmp word ptr [bp+10], 36
              jnz intr_37
              int 36
              jmp intr_fin
intr_37:
              cmp word ptr [bp+10], 37
              jnz intr_38
              int 37
              jmp intr_fin
intr_38:
              cmp word ptr [bp+10], 38
              jnz intr_39
              int 38
              jmp intr_fin
intr_39:
              cmp word ptr [bp+10], 39
              jnz intr_40
              int 39
              jmp intr_fin
intr_40:
              cmp word ptr [bp+10], 40
              jnz intr_41
              int 40
              jmp intr_fin
intr_41:
              cmp word ptr [bp+10], 41
              jnz intr_42
              int 41
              jmp intr_fin
intr_42:
              cmp word ptr [bp+10], 42
              jnz intr_43
              int 42
              jmp intr_fin
intr_43:
              cmp word ptr [bp+10], 43
              jnz intr_44
              int 43
              jmp intr_fin
intr_44:
              cmp word ptr [bp+10], 44
              jnz intr_45
              int 44
              jmp intr_fin
intr_45:
              cmp word ptr [bp+10], 45
              jnz intr_46
              int 45
              jmp intr_fin
intr_46:
              cmp word ptr [bp+10], 46
              jnz intr_47
              int 46
              jmp intr_fin
intr_47:
              cmp word ptr [bp+10], 47
              jnz intr_48
              int 47
              jmp intr_fin
intr_48:
              cmp word ptr [bp+10], 48
              jnz intr_49
              int 48
              jmp intr_fin
intr_49:
              cmp word ptr [bp+10], 49
              jnz intr_50
              int 49
              jmp intr_fin
intr_50:
              cmp word ptr [bp+10], 50
              jnz intr_51
              int 50
              jmp intr_fin
intr_51:
              cmp word ptr [bp+10], 51
              jnz intr_52
              int 51
              jmp intr_fin
intr_52:
              cmp word ptr [bp+10], 52
              jnz intr_53
              int 52
              jmp intr_fin
intr_53:
              cmp word ptr [bp+10], 53
              jnz intr_54
              int 53
              jmp intr_fin
intr_54:
              cmp word ptr [bp+10], 54
              jnz intr_55
              int 54
              jmp intr_fin
intr_55:
              cmp word ptr [bp+10], 55
              jnz intr_56
              int 55
              jmp intr_fin
intr_56:
              cmp word ptr [bp+10], 56
              jnz intr_57
              int 56
              jmp intr_fin
intr_57:
              cmp word ptr [bp+10], 57
              jnz intr_58
              int 57
              jmp intr_fin
intr_58:
              cmp word ptr [bp+10], 58
              jnz intr_59
              int 58
              jmp intr_fin
intr_59:
              cmp word ptr [bp+10], 59
              jnz intr_60
              int 59
              jmp intr_fin
intr_60:
              cmp word ptr [bp+10], 60
              jnz intr_61
              int 60
              jmp intr_fin
intr_61:
              cmp word ptr [bp+10], 61
              jnz intr_62
              int 61
              jmp intr_fin
intr_62:
              cmp word ptr [bp+10], 62
              jnz intr_63
              int 62
              jmp intr_fin
intr_63:
              cmp word ptr [bp+10], 63
              jnz intr_64
              int 63
              jmp intr_fin
intr_64:
              cmp word ptr [bp+10], 64
              jnz intr_65
              int 64
              jmp intr_fin
intr_65:
              cmp word ptr [bp+10], 65
              jnz intr_66
              int 65
              jmp intr_fin
intr_66:
              cmp word ptr [bp+10], 66
              jnz intr_67
              int 66
              jmp intr_fin
intr_67:
              cmp word ptr [bp+10], 67
              jnz intr_68
              int 67
              jmp intr_fin
intr_68:
              cmp word ptr [bp+10], 68
              jnz intr_69
              int 68
              jmp intr_fin
intr_69:
              cmp word ptr [bp+10], 69
              jnz intr_70
              int 69
              jmp intr_fin
intr_70:
              cmp word ptr [bp+10], 70
              jnz intr_71
              int 70
              jmp intr_fin
intr_71:
              cmp word ptr [bp+10], 71
              jnz intr_72
              int 71
              jmp intr_fin
intr_72:
              cmp word ptr [bp+10], 72
              jnz intr_73
              int 72
              jmp intr_fin
intr_73:
              cmp word ptr [bp+10], 73
              jnz intr_74
              int 73
              jmp intr_fin
intr_74:
              cmp word ptr [bp+10], 74
              jnz intr_75
              int 74
              jmp intr_fin
intr_75:
              cmp word ptr [bp+10], 75
              jnz intr_76
              int 75
              jmp intr_fin
intr_76:
              cmp word ptr [bp+10], 76
              jnz intr_77
              int 76
              jmp intr_fin
intr_77:
              cmp word ptr [bp+10], 77
              jnz intr_78
              int 77
              jmp intr_fin
intr_78:
              cmp word ptr [bp+10], 78
              jnz intr_79
              int 78
              jmp intr_fin
intr_79:
              cmp word ptr [bp+10], 79
              jnz intr_80
              int 79
              jmp intr_fin
intr_80:
              cmp word ptr [bp+10], 80
              jnz intr_81
              int 80
              jmp intr_fin
intr_81:
              cmp word ptr [bp+10], 81
              jnz intr_82
              int 81
              jmp intr_fin
intr_82:
              cmp word ptr [bp+10], 82
              jnz intr_83
              int 82
              jmp intr_fin
intr_83:
              cmp word ptr [bp+10], 83
              jnz intr_84
              int 83
              jmp intr_fin
intr_84:
              cmp word ptr [bp+10], 84
              jnz intr_85
              int 84
              jmp intr_fin
intr_85:
              cmp word ptr [bp+10], 85
              jnz intr_86
              int 85
              jmp intr_fin
intr_86:
              cmp word ptr [bp+10], 86
              jnz intr_87
              int 86
              jmp intr_fin
intr_87:
              cmp word ptr [bp+10], 87
              jnz intr_88
              int 87
              jmp intr_fin
intr_88:
              cmp word ptr [bp+10], 88
              jnz intr_89
              int 88
              jmp intr_fin
intr_89:
              cmp word ptr [bp+10], 89
              jnz intr_90
              int 89
              jmp intr_fin
intr_90:
              cmp word ptr [bp+10], 90
              jnz intr_91
              int 90
              jmp intr_fin
intr_91:
              cmp word ptr [bp+10], 91
              jnz intr_92
              int 91
              jmp intr_fin
intr_92:
              cmp word ptr [bp+10], 92
              jnz intr_93
              int 92
              jmp intr_fin
intr_93:
              cmp word ptr [bp+10], 93
              jnz intr_94
              int 93
              jmp intr_fin
intr_94:
              cmp word ptr [bp+10], 94
              jnz intr_95
              int 94
              jmp intr_fin
intr_95:
              cmp word ptr [bp+10], 95
              jnz intr_96
              int 95
              jmp intr_fin
intr_96:
              cmp word ptr [bp+10], 96
              jnz intr_97
              int 96
              jmp intr_fin
intr_97:
              cmp word ptr [bp+10], 97
              jnz intr_98
              int 97
              jmp intr_fin
intr_98:
              cmp word ptr [bp+10], 98
              jnz intr_99
              int 98
              jmp intr_fin
intr_99:
              cmp word ptr [bp+10], 99
              jnz intr_100
              int 99
              jmp intr_fin
intr_100:
              cmp word ptr [bp+10], 100
              jnz intr_101
              int 100
              jmp intr_fin
intr_101:
              cmp word ptr [bp+10], 101
              jnz intr_102
              int 101
              jmp intr_fin
intr_102:
              cmp word ptr [bp+10], 102
              jnz intr_103
              int 102
              jmp intr_fin
intr_103:
              cmp word ptr [bp+10], 103
              jnz intr_104
              int 103
              jmp intr_fin
intr_104:
              cmp word ptr [bp+10], 104
              jnz intr_105
              int 104
              jmp intr_fin
intr_105:
              cmp word ptr [bp+10], 105
              jnz intr_106
              int 105
              jmp intr_fin
intr_106:
              cmp word ptr [bp+10], 106
              jnz intr_107
              int 106
              jmp intr_fin
intr_107:
              cmp word ptr [bp+10], 107
              jnz intr_108
              int 107
              jmp intr_fin
intr_108:
              cmp word ptr [bp+10], 108
              jnz intr_109
              int 108
              jmp intr_fin
intr_109:
              cmp word ptr [bp+10], 109
              jnz intr_110
              int 109
              jmp intr_fin
intr_110:
              cmp word ptr [bp+10], 110
              jnz intr_111
              int 110
              jmp intr_fin
intr_111:
              cmp word ptr [bp+10], 111
              jnz intr_112
              int 111
              jmp intr_fin
intr_112:
              cmp word ptr [bp+10], 112
              jnz intr_113
              int 112
              jmp intr_fin
intr_113:
              cmp word ptr [bp+10], 113
              jnz intr_114
              int 113
              jmp intr_fin
intr_114:
              cmp word ptr [bp+10], 114
              jnz intr_115
              int 114
              jmp intr_fin
intr_115:
              cmp word ptr [bp+10], 115
              jnz intr_116
              int 115
              jmp intr_fin
intr_116:
              cmp word ptr [bp+10], 116
              jnz intr_117
              int 116
              jmp intr_fin
intr_117:
              cmp word ptr [bp+10], 117
              jnz intr_118
              int 117
              jmp intr_fin
intr_118:
              cmp word ptr [bp+10], 118
              jnz intr_119
              int 118
              jmp intr_fin
intr_119:
              cmp word ptr [bp+10], 119
              jnz intr_120
              int 119
              jmp intr_fin
intr_120:
              cmp word ptr [bp+10], 120
              jnz intr_121
              int 120
              jmp intr_fin
intr_121:
              cmp word ptr [bp+10], 121
              jnz intr_122
              int 121
              jmp intr_fin
intr_122:
              cmp word ptr [bp+10], 122
              jnz intr_123
              int 122
              jmp intr_fin
intr_123:
              cmp word ptr [bp+10], 123
              jnz intr_124
              int 123
              jmp intr_fin
intr_124:
              cmp word ptr [bp+10], 124
              jnz intr_125
              int 124
              jmp intr_fin
intr_125:
              cmp word ptr [bp+10], 125
              jnz intr_126
              int 125
              jmp intr_fin
intr_126:
              cmp word ptr [bp+10], 126
              jnz intr_127
              int 126
              jmp intr_fin
intr_127:
              cmp word ptr [bp+10], 127
              jnz intr_128
              int 127
              jmp intr_fin
intr_128:
              cmp word ptr [bp+10], 128
              jnz intr_129
              int 128
              jmp intr_fin
intr_129:
              cmp word ptr [bp+10], 129
              jnz intr_130
              int 129
              jmp intr_fin
intr_130:
              cmp word ptr [bp+10], 130
              jnz intr_131
              int 130
              jmp intr_fin
intr_131:
              cmp word ptr [bp+10], 131
              jnz intr_132
              int 131
              jmp intr_fin
intr_132:
              cmp word ptr [bp+10], 132
              jnz intr_133
              int 132
              jmp intr_fin
intr_133:
              cmp word ptr [bp+10], 133
              jnz intr_134
              int 133
              jmp intr_fin
intr_134:
              cmp word ptr [bp+10], 134
              jnz intr_135
              int 134
              jmp intr_fin
intr_135:
              cmp word ptr [bp+10], 135
              jnz intr_136
              int 135
              jmp intr_fin
intr_136:
              cmp word ptr [bp+10], 136
              jnz intr_137
              int 136
              jmp intr_fin
intr_137:
              cmp word ptr [bp+10], 137
              jnz intr_138
              int 137
              jmp intr_fin
intr_138:
              cmp word ptr [bp+10], 138
              jnz intr_139
              int 138
              jmp intr_fin
intr_139:
              cmp word ptr [bp+10], 139
              jnz intr_140
              int 139
              jmp intr_fin
intr_140:
              cmp word ptr [bp+10], 140
              jnz intr_141
              int 140
              jmp intr_fin
intr_141:
              cmp word ptr [bp+10], 141
              jnz intr_142
              int 141
              jmp intr_fin
intr_142:
              cmp word ptr [bp+10], 142
              jnz intr_143
              int 142
              jmp intr_fin
intr_143:
              cmp word ptr [bp+10], 143
              jnz intr_144
              int 143
              jmp intr_fin
intr_144:
              cmp word ptr [bp+10], 144
              jnz intr_145
              int 144
              jmp intr_fin
intr_145:
              cmp word ptr [bp+10], 145
              jnz intr_146
              int 145
              jmp intr_fin
intr_146:
              cmp word ptr [bp+10], 146
              jnz intr_147
              int 146
              jmp intr_fin
intr_147:
              cmp word ptr [bp+10], 147
              jnz intr_148
              int 147
              jmp intr_fin
intr_148:
              cmp word ptr [bp+10], 148
              jnz intr_149
              int 148
              jmp intr_fin
intr_149:
              cmp word ptr [bp+10], 149
              jnz intr_150
              int 149
              jmp intr_fin
intr_150:
              cmp word ptr [bp+10], 150
              jnz intr_151
              int 150
              jmp intr_fin
intr_151:
              cmp word ptr [bp+10], 151
              jnz intr_152
              int 151
              jmp intr_fin
intr_152:
              cmp word ptr [bp+10], 152
              jnz intr_153
              int 152
              jmp intr_fin
intr_153:
              cmp word ptr [bp+10], 153
              jnz intr_154
              int 153
              jmp intr_fin
intr_154:
              cmp word ptr [bp+10], 154
              jnz intr_155
              int 154
              jmp intr_fin
intr_155:
              cmp word ptr [bp+10], 155
              jnz intr_156
              int 155
              jmp intr_fin
intr_156:
              cmp word ptr [bp+10], 156
              jnz intr_157
              int 156
              jmp intr_fin
intr_157:
              cmp word ptr [bp+10], 157
              jnz intr_158
              int 157
              jmp intr_fin
intr_158:
              cmp word ptr [bp+10], 158
              jnz intr_159
              int 158
              jmp intr_fin
intr_159:
              cmp word ptr [bp+10], 159
              jnz intr_160
              int 159
              jmp intr_fin
intr_160:
              cmp word ptr [bp+10], 160
              jnz intr_161
              int 160
              jmp intr_fin
intr_161:
              cmp word ptr [bp+10], 161
              jnz intr_162
              int 161
              jmp intr_fin
intr_162:
              cmp word ptr [bp+10], 162
              jnz intr_163
              int 162
              jmp intr_fin
intr_163:
              cmp word ptr [bp+10], 163
              jnz intr_164
              int 163
              jmp intr_fin
intr_164:
              cmp word ptr [bp+10], 164
              jnz intr_165
              int 164
              jmp intr_fin
intr_165:
              cmp word ptr [bp+10], 165
              jnz intr_166
              int 165
              jmp intr_fin
intr_166:
              cmp word ptr [bp+10], 166
              jnz intr_167
              int 166
              jmp intr_fin
intr_167:
              cmp word ptr [bp+10], 167
              jnz intr_168
              int 167
              jmp intr_fin
intr_168:
              cmp word ptr [bp+10], 168
              jnz intr_169
              int 168
              jmp intr_fin
intr_169:
              cmp word ptr [bp+10], 169
              jnz intr_170
              int 169
              jmp intr_fin
intr_170:
              cmp word ptr [bp+10], 170
              jnz intr_171
              int 170
              jmp intr_fin
intr_171:
              cmp word ptr [bp+10], 171
              jnz intr_172
              int 171
              jmp intr_fin
intr_172:
              cmp word ptr [bp+10], 172
              jnz intr_173
              int 172
              jmp intr_fin
intr_173:
              cmp word ptr [bp+10], 173
              jnz intr_174
              int 173
              jmp intr_fin
intr_174:
              cmp word ptr [bp+10], 174
              jnz intr_175
              int 174
              jmp intr_fin
intr_175:
              cmp word ptr [bp+10], 175
              jnz intr_176
              int 175
              jmp intr_fin
intr_176:
              cmp word ptr [bp+10], 176
              jnz intr_177
              int 176
              jmp intr_fin
intr_177:
              cmp word ptr [bp+10], 177
              jnz intr_178
              int 177
              jmp intr_fin
intr_178:
              cmp word ptr [bp+10], 178
              jnz intr_179
              int 178
              jmp intr_fin
intr_179:
              cmp word ptr [bp+10], 179
              jnz intr_180
              int 179
              jmp intr_fin
intr_180:
              cmp word ptr [bp+10], 180
              jnz intr_181
              int 180
              jmp intr_fin
intr_181:
              cmp word ptr [bp+10], 181
              jnz intr_182
              int 181
              jmp intr_fin
intr_182:
              cmp word ptr [bp+10], 182
              jnz intr_183
              int 182
              jmp intr_fin
intr_183:
              cmp word ptr [bp+10], 183
              jnz intr_184
              int 183
              jmp intr_fin
intr_184:
              cmp word ptr [bp+10], 184
              jnz intr_185
              int 184
              jmp intr_fin
intr_185:
              cmp word ptr [bp+10], 185
              jnz intr_186
              int 185
              jmp intr_fin
intr_186:
              cmp word ptr [bp+10], 186
              jnz intr_187
              int 186
              jmp intr_fin
intr_187:
              cmp word ptr [bp+10], 187
              jnz intr_188
              int 187
              jmp intr_fin
intr_188:
              cmp word ptr [bp+10], 188
              jnz intr_189
              int 188
              jmp intr_fin
intr_189:
              cmp word ptr [bp+10], 189
              jnz intr_190
              int 189
              jmp intr_fin
intr_190:
              cmp word ptr [bp+10], 190
              jnz intr_191
              int 190
              jmp intr_fin
intr_191:
              cmp word ptr [bp+10], 191
              jnz intr_192
              int 191
              jmp intr_fin
intr_192:
              cmp word ptr [bp+10], 192
              jnz intr_193
              int 192
              jmp intr_fin
intr_193:
              cmp word ptr [bp+10], 193
              jnz intr_194
              int 193
              jmp intr_fin
intr_194:
              cmp word ptr [bp+10], 194
              jnz intr_195
              int 194
              jmp intr_fin
intr_195:
              cmp word ptr [bp+10], 195
              jnz intr_196
              int 195
              jmp intr_fin
intr_196:
              cmp word ptr [bp+10], 196
              jnz intr_197
              int 196
              jmp intr_fin
intr_197:
              cmp word ptr [bp+10], 197
              jnz intr_198
              int 197
              jmp intr_fin
intr_198:
              cmp word ptr [bp+10], 198
              jnz intr_199
              int 198
              jmp intr_fin
intr_199:
              cmp word ptr [bp+10], 199
              jnz intr_200
              int 199
              jmp intr_fin
intr_200:
              cmp word ptr [bp+10], 200
              jnz intr_201
              int 200
              jmp intr_fin
intr_201:
              cmp word ptr [bp+10], 201
              jnz intr_202
              int 201
              jmp intr_fin
intr_202:
              cmp word ptr [bp+10], 202
              jnz intr_203
              int 202
              jmp intr_fin
intr_203:
              cmp word ptr [bp+10], 203
              jnz intr_204
              int 203
              jmp intr_fin
intr_204:
              cmp word ptr [bp+10], 204
              jnz intr_205
              int 204
              jmp intr_fin
intr_205:
              cmp word ptr [bp+10], 205
              jnz intr_206
              int 205
              jmp intr_fin
intr_206:
              cmp word ptr [bp+10], 206
              jnz intr_207
              int 206
              jmp intr_fin
intr_207:
              cmp word ptr [bp+10], 207
              jnz intr_208
              int 207
              jmp intr_fin
intr_208:
              cmp word ptr [bp+10], 208
              jnz intr_209
              int 208
              jmp intr_fin
intr_209:
              cmp word ptr [bp+10], 209
              jnz intr_210
              int 209
              jmp intr_fin
intr_210:
              cmp word ptr [bp+10], 210
              jnz intr_211
              int 210
              jmp intr_fin
intr_211:
              cmp word ptr [bp+10], 211
              jnz intr_212
              int 211
              jmp intr_fin
intr_212:
              cmp word ptr [bp+10], 212
              jnz intr_213
              int 212
              jmp intr_fin
intr_213:
              cmp word ptr [bp+10], 213
              jnz intr_214
              int 213
              jmp intr_fin
intr_214:
              cmp word ptr [bp+10], 214
              jnz intr_215
              int 214
              jmp intr_fin
intr_215:
              cmp word ptr [bp+10], 215
              jnz intr_216
              int 215
              jmp intr_fin
intr_216:
              cmp word ptr [bp+10], 216
              jnz intr_217
              int 216
              jmp intr_fin
intr_217:
              cmp word ptr [bp+10], 217
              jnz intr_218
              int 217
              jmp intr_fin
intr_218:
              cmp word ptr [bp+10], 218
              jnz intr_219
              int 218
              jmp intr_fin
intr_219:
              cmp word ptr [bp+10], 219
              jnz intr_220
              int 219
              jmp intr_fin
intr_220:
              cmp word ptr [bp+10], 220
              jnz intr_221
              int 220
              jmp intr_fin
intr_221:
              cmp word ptr [bp+10], 221
              jnz intr_222
              int 221
              jmp intr_fin
intr_222:
              cmp word ptr [bp+10], 222
              jnz intr_223
              int 222
              jmp intr_fin
intr_223:
              cmp word ptr [bp+10], 223
              jnz intr_224
              int 223
              jmp intr_fin
intr_224:
              cmp word ptr [bp+10], 224
              jnz intr_225
              int 224
              jmp intr_fin
intr_225:
              cmp word ptr [bp+10], 225
              jnz intr_226
              int 225
              jmp intr_fin
intr_226:
              cmp word ptr [bp+10], 226
              jnz intr_227
              int 226
              jmp intr_fin
intr_227:
              cmp word ptr [bp+10], 227
              jnz intr_228
              int 227
              jmp intr_fin
intr_228:
              cmp word ptr [bp+10], 228
              jnz intr_229
              int 228
              jmp intr_fin
intr_229:
              cmp word ptr [bp+10], 229
              jnz intr_230
              int 229
              jmp intr_fin
intr_230:
              cmp word ptr [bp+10], 230
              jnz intr_231
              int 230
              jmp intr_fin
intr_231:
              cmp word ptr [bp+10], 231
              jnz intr_232
              int 231
              jmp intr_fin
intr_232:
              cmp word ptr [bp+10], 232
              jnz intr_233
              int 232
              jmp intr_fin
intr_233:
              cmp word ptr [bp+10], 233
              jnz intr_234
              int 233
              jmp intr_fin
intr_234:
              cmp word ptr [bp+10], 234
              jnz intr_235
              int 234
              jmp intr_fin
intr_235:
              cmp word ptr [bp+10], 235
              jnz intr_236
              int 235
              jmp intr_fin
intr_236:
              cmp word ptr [bp+10], 236
              jnz intr_237
              int 236
              jmp intr_fin
intr_237:
              cmp word ptr [bp+10], 237
              jnz intr_238
              int 237
              jmp intr_fin
intr_238:
              cmp word ptr [bp+10], 238
              jnz intr_239
              int 238
              jmp intr_fin
intr_239:
              cmp word ptr [bp+10], 239
              jnz intr_240
              int 239
              jmp intr_fin
intr_240:
              cmp word ptr [bp+10], 240
              jnz intr_241
              int 240
              jmp intr_fin
intr_241:
              cmp word ptr [bp+10], 241
              jnz intr_242
              int 241
              jmp intr_fin
intr_242:
              cmp word ptr [bp+10], 242
              jnz intr_243
              int 242
              jmp intr_fin
intr_243:
              cmp word ptr [bp+10], 243
              jnz intr_244
              int 243
              jmp intr_fin
intr_244:
              cmp word ptr [bp+10], 244
              jnz intr_245
              int 244
              jmp intr_fin
intr_245:
              cmp word ptr [bp+10], 245
              jnz intr_246
              int 245
              jmp intr_fin
intr_246:
              cmp word ptr [bp+10], 246
              jnz intr_247
              int 246
              jmp intr_fin
intr_247:
              cmp word ptr [bp+10], 247
              jnz intr_248
              int 247
              jmp intr_fin
intr_248:
              cmp word ptr [bp+10], 248
              jnz intr_249
              int 248
              jmp intr_fin
intr_249:
              cmp word ptr [bp+10], 249
              jnz intr_250
              int 249
              jmp intr_fin
intr_250:
              cmp word ptr [bp+10], 250
              jnz intr_251
              int 250
              jmp intr_fin
intr_251:
              cmp word ptr [bp+10], 251
              jnz intr_252
              int 251
              jmp intr_fin
intr_252:
              cmp word ptr [bp+10], 252
              jnz intr_253
              int 252
              jmp intr_fin
intr_253:
              cmp word ptr [bp+10], 253
              jnz intr_254
              int 253
              jmp intr_fin
intr_254:
              cmp word ptr [bp+10], 254
              jnz intr_255
              int 254
              jmp intr_fin
intr_255:
              cmp word ptr [bp+10], 255
              jnz intr_fin
              int 255
              jmp intr_fin
; mise des resultats dans le RECORD pass‚ par adresse.
intr_fin:
              mov ds:[si], ax
              mov ds:[si+2], bx
              mov ds:[si+4], cx
              mov ds:[si+6], dx
; restauration des registres.
              popf
              pop es
              pop ds
              pop di
              pop si
              pop dx
              pop cx
              pop bx
              pop ax
              pop bp
; retour avec d‚pilage des 6 octets des paramŠtres pass‚s: 2 pour num‚ro de INT
;                                                          4 pour REGISTRES
              ret 6
;
intr          endp
; fin du programme.
code          ends
              end
