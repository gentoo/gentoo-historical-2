# Distributed under the terms of the GNU General Public License, v2 or later
# Author Nathaniel Hirsch <nh2@njit.edu> Achim Gottinge <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-video/vlc/vlc-0.2.91.ebuild,v 1.5 2002/05/23 06:50:14 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="DVD / video player"
SRC_URI="http://www.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.gz"
HOMEPAGE="http://www.videolan.org"

DEPEND=">=media-libs/libsdl-1.1.8-r1
	gnome? ( >=gnome-base/gnome-libs-1.4.1.2-r1 )
    esd? ( >=media-sound/esound-0.2.22 )
    ggi? ( >=media-libs/libggi-2.0_beta3 )
    qt? ( =x11-libs/qt-2.3* )
    gtk? ( =x11-libs/gtk+-1.2* )
    X? ( virtual/x11 )"
    #alsa? ( >=media-libs/alsa-lib-0.5.10 )
    #kde? ( >=kde-base/kdelibs-2.1.1 )

src_compile(){
    local myconf
	if [ "`use fbdev`" ]
    then
      myconf="--enable-fb"
    fi
    if [ -z "`use mmx`" ]
    then
      myconf="$myconf --disable-mmx"
    fi
    if [ "`use esd`" ]
    then
      myconf="$myconf --enable-esd"
    fi
    if [ "`use ggi`" ]
    then
      myconf="$myconf --with-ggi"
    fi
    if [ "`use qt`" ]
    then
      export QTDIR=/usr/qt/2
      myconf="$myconf --enable-qt"
    fi
    #if [ "`use kde`" ]
    #then
    #  myconf="$myconf --enable-kde"
    #fi
    if [ "`use gnome`" ]
    then
      myconf="$myconf --enable-gnome"
    fi
    if [ -z "`use gtk`" ]
    then
      myconf="$myconf --disable-gtk"
    fi
    if [ "`use X`" ]
    then
      myconf="$myconf --enable-xvideo"
    else
      myconf="$myconf --disable-x11"
    fi

#    Currently alsa support in vlc requires Alsa 0.90 (which is unstable).
#    Until some release of alsa is released which works with vlc don't use it.
#    if [ "`use alsa`" ]
#    then
#      myconf="$myconf --enable-alsa"
#    fi

    # vlc uses its own ultraoptimizaed CXXFLAGS, and forcing custom ones generally fails building
    export CXXFLAGS=""
    export CFLAGS=""
    
    ./configure --prefix=/usr $myconf --with-sdl --disable-alsa --enable-release || die
    make || die
}

src_install() {

    dodir /usr/{bin,lib}
    make DESTDIR=${D} install || die

}

