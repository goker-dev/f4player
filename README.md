f4Player
=========
_Free, Small, Quick, Customizable and the Bestest FLV Player on Internet!_

f4Player is an **open source** [**flash**][1] ([**AS3**][2]) **video player** and library project. 
It is so small that it is **only 10kb** (with skin file) and totally **free** under **GPL** license.

I've only tested it with **flv**, **f4v**, **mp4**, **stream**, **live stream**, **subscribed CDN**
 and it works enough for me for now! 

You can check it on [gokercebeci.com/dev/f4player][3].

USAGE
-------

        <object id="f4Player" width="480" height="270" type="application/x-shockwave-flash" data="player.swf?v1.3.5"> 
          <param name="movie" value="player.swf?v1.3.5" /> 
          <param name="quality" value="high" /> 
          <param name="menu" value="false" /> 
          <param name="scale" value="noscale" /> 
          <param name="allowfullscreen" value="true"> 
          <param name="allowscriptaccess" value="always"> 
          <param name="swlivevonnect" value="true" /> 
          <param name="cachebusting" value="false"> 
          <param name="flashvars"   value="skin=[SKIN_FILE]&video=[VIDEO_FILE]"/> 
          <a href="http://www.adobe.com/go/flashplayer/">Download it from Adobe.</a> 
          <a href="http://gokercebeci.com/dev/f4player" title="flv player">flv player</a> 
        </object>
    
OR

        <embed type="application/x-shockwave-flash" src="player.swf?v1.3.5" id="f4Player" width="480" height="270" flashvars="skin=[SKIN_FILE]&video=[VIDEO_FILE]" allowscriptaccess="always" allowfullscreen="true" bgcolor="#000000"/> 
        <noembed> 
           You need Adobe Flash Player to watch this video. 
           <a href="http://get.adobe.com/flashplayer/">Download it from Adobe.</a> 
           <a href="http://gokercebeci.com/dev/f4player" title="flv player">flv player</a> 
        </noembed>

    
OPTIONS
-------

        skin=                   => skin file (swf)
        stream=rtmp://          => stream url
        streamname=livestream   => stream name
        live=1                  => default value 0
        subscribe=1             => default value 0
        thumbnail=null          => thumbnail image
        video=myvideo.mp4       => video file
        autoplay=1              => default value 0    


LICENSE
-------
It is under the [GPL License][4].

WHO'S USING f4Player
-------
* [showtvnet.com][5]
* [skyturk360.com][6]
* [gradiska.tv][7]
* [mirtom.pl][8]

_If you use f4Player and want to be in the list, mention me with **#f4Player** [**@gokercebeci**][9] on twitter_

[1]: http://www.adobe.com/software/flash/about/
[2]: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/index.html
[3]: http://gokercebeci.com/dev/f4player?feature=github
[4]: https://github.com/gokercebeci/f4player/blob/master/LICENSE.md
[5]: http://www.showtv.com.tr/player/index.asp?ptype=1&product=showtv
[6]: http://skyturk360.com/canli.asp
[7]: http://gradiska.tv/index.php?page=video&page2=1&video=2012-12-27_10-38_paketicicenatarzasocrad&cat=Novosti
[8]: http://mirtom.pl/
[9]: https://twitter.com/gokercebeci


