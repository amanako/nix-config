{ inputs, ... }:

{
  flake.modules.nixos.fontconfig = {
    fonts.fontconfig.localConf = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
      <fontconfig>
        <!--    Default font (no fc-match pattern)    -->
        <!-- <match>                                  -->
        <!--  <edit mode="prepend" name="family">     -->
        <!-- <string>Mona Sans Display Light</string> -->
        <!-- </edit>                                  -->
        <!-- </match>                                 -->
        <!-- Default font for the ja_JP locale (no fc-match pattern) -->
        <match>
          <test compare="contains" name="lang">
            <string>ja</string>
          </test>
          <edit mode="prepend" name="family">
            <string>IPAMincho</string>
          </edit>
        </match>
        <!-- Default sans-serif font -->
        <match target="pattern">
          <test qual="any" name="family">
            <string>sans-serif</string>
          </test>
          <!--<test qual="any" name="lang"><string>ja</string></test>-->
          <edit name="family" mode="prepend" binding="same">
            <string>Biz UDPGothic</string>
          </edit>
        </match>
        <!-- Default serif fonts -->
        <match target="pattern">
          <test qual="any" name="family">
            <string>serif</string>
          </test>
      		<edit name="family" mode="append" binding="same">
            <string>IPAMincho</string>
          </edit>
          <edit name="family" mode="prepend" binding="same">
            <string>Noto Serif</string>
          </edit>
              <edit name="family" mode="append" binding="same">
            <string>HanaMinA</string>
          </edit>
        </match>
        <!-- Default monospace fonts -->
        <match target="pattern">
          <test qual="any" name="family">
            <string>monospace</string>
          </test>
          <edit name="family" mode="prepend" binding="same">
            <string>Mona Sans Mono</string>
          </edit>
          <edit name="family" mode="append" binding="same">
            <string>Inconsolatazi4</string>
          </edit>
          
        </match>
        <!-- Fallback fonts preference order -->
        <alias>
          <family>sans-serif</family>
          <prefer>
      			<family>Biz UDPGothic</family>
            <family>IPAPGothic</family>
            <family>Noto Sans</family>
            <family>Open Sans</family>
            <family>Droid Sans</family>
            <family>Ubuntu</family>
            <family>Roboto</family>
            <family>NotoSansCJK</family>
            <family>Source Han Sans JP</family>
            <family>VL PGothic</family>
            <family>Koruri</family>
          </prefer>
        </alias>
        <alias>
          <family>serif</family>
          <prefer>
            <family>IPAPMincho</family>
      			<family>Mona Sans Display Medium</family>
            <family>Noto Serif</family>
            <family>Droid Serif</family>
            <family>Roboto Slab</family>
          </prefer>
        </alias>
        <alias>
          <family>monospace</family>
          <prefer>
            <family>Mona Sans Mono Light</family>
            <family>IPAGothic</family>
            <family>Inconsolatazi4</family>
            <family>Ubuntu Mono</family>
            <family>Droid Sans Mono</family>
            <family>Roboto Mono</family>
          </prefer>
        </alias>
      </fontconfig>
      	'';
  };
}
