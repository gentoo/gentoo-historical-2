# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later

inherit makeedit flag-o-matic gcc

EMVER="0.65.2"
IPCVER="1.0.0.1"

MY_PN=${PN/-cvs/}
MY_PV1=${PV/_}
MY_PV2=${MY_PV1/eta}
S=${WORKDIR}/mozilla
DESCRIPTION="The Phoenix Web Browser"
#SRC_URI="ftp://ftp.mozilla.org/pub/mozilla/nightly/latest/mozilla-source.tar.bz2"
HOMEPAGE="http://www.mozilla.org/projects/phoenix/"

KEYWORDS="~x86 ~ppc ~sparc ~sparc64"
SLOT="0"
LICENSE="MPL-1.1 | NPL-1.1"
IUSE="java gtk2 ipv6"

RDEPEND="virtual/x11
   >=dev-libs/libIDL-0.8.0
   >=gnome-base/ORBit-0.5.10-r1
   >=x11-libs/xft-2.0
   >=sys-libs/zlib-1.1.4
   >=media-libs/jpeg-6b
   >=media-libs/libmng-1.0.0
   >=media-libs/libpng-1.2.1
   >=sys-apps/portage-2.0.36
   dev-libs/expat
   app-arch/zip
   app-arch/unzip
   ( gtk2? >=x11-libs/gtk+-2.1.1 :
     =x11-libs/gtk+-1.2* )
   java?  ( virtual/jre )
	!net-www/phoenix-bin"

DEPEND="${RDEPEND}
   virtual/glibc
   dev-lang/perl
   dev-util/cvs
   java? ( >=dev-java/java-config-0.2.0 )"
   
# needed by src_compile() and src_install()
export MOZ_PHOENIX=1
export MOZ_CALENDAR=0
export MOZ_ENABLE_XFT=1

src_unpack() {
#   unpack ${A}
   addwrite ${DISTDIR}/cvs-src
   mkdir -p ${DISTDIR}/cvs-src/
   cd ${DISTDIR}/cvs-src/
   echo ":pserver:anonymous@cvs-mirror.mozilla.org:/cvsroot A" > "${T}/cvspass"
   export CVS_PASSFILE="${T}/cvspass"
   einfo "Checking out latest Mozilla from CVS..."
   einfo "[ mozilla/browser & mozilla/toolkit ]"
   cvs -z3 -d:pserver:anonymous@cvs-mirror.mozilla.org:/cvsroot checkout mozilla/browser mozilla/toolkit mozilla/client.mk
   make -f mozilla/client.mk checkout
   cp -a mozilla ${S}
   cd ${S}
   # Fix a ownership porblem
   chown -R root.root *
}

src_compile() {
   local myconf="--disable-composer \
      --with-x \
      --with-system-jpeg \
      --with-system-zlib \
      --with-system-png \
      --with-system-mng \
      --disable-mailnews \
      --disable-calendar \
      --enable-xft \
      --disable-pedantic \
      --disable-svg \
      --enable-mathml \
      --without-system-nspr \
      --enable-nspr-autoconf \
      --enable-xsl \
      --enable-crypto \
      --enable-xinerama=no \
      --with-java-supplement \
      --with-pthreads \
      --with-default-mozilla-five-home=/usr/lib/phoenix \
      --with-user-appdir=.phoenix \
      --disable-jsd \
      --disable-accessibility \
      --disable-tests \
      --disable-debug \
      --disable-dtd-debug \
      --disable-logging \
      --enable-reorder \
      --enable-strip \
      --enable-strip-libs \
      --enable-cpp-rtti \
      --enable-xterm-updates \
      --disable-ldap"

    if [ -n "`use gtk2`" ] ; then
        myconf="${myconf} --enable-toolkit-gtk2 \
                          --enable-default-toolkit=gtk2 \
                          --disable-toolkit-qt \
                          --disable-toolkit-xlib \
                          --disable-toolkit-gtk"
    else

        myconf="${myconf} --enable-toolkit-gtk \
                          --enable-default-toolkit=gtk \
                          --disable-toolkit-qt \
                          --disable-toolkit-xlib \
                          --disable-toolkit-gtk2"

    fi

    if [ -n "`use ipv6`" ] ; then
        myconf="${myconf} --enable-ipv6"
    fi

   # Crashes on start when compiled with -fomit-frame-pointer
   CFLAGS="${CFLAGS/-fomit-frame-pointer} -s -fforce-addr"
   CXXFLAGS="${CXXFLAGS/-fomit-frame-pointer} -s -fforce-addr -Wno-deprecated"
   
   #CFLAGS="-Os -march=pentium3 -pipe -s -fforce-addr"
   #CXXFLAGS="-Os -march=pentium3 -pipe -s -fforce-addr -Wno-deprecated"

   if [ "$(gcc-major-version)" -eq "3" ]; then
      # Currently gcc-3.2 or older do not work well if we specify "-march"
      # and other optimizations for pentium4.
      CFLAGS="${CFLAGS/-march=pentium4/-march=pentium3}"
      CXXFLAGS="${CXXFLAGS/-march=pentium4/-march=pentium3}"
   
      # Enable us to use flash, etc plugins compiled with gcc-2.95.3
      if [ "${ARCH}" = "x86" ]; then
          myconf="${myconf} --enable-old-abi-compat-wrappers"
       fi
   fi

   ./configure --prefix=/usr \
      ${myconf} || die

   edit_makefiles
   emake MOZ_PHOENIX=1 || die
}

src_install() {
   # Plugin path creation
    PLUGIN_DIR="/usr/lib/nsbrowser/plugins"
    dodir /${PLUGIN_DIR}

   dodir /usr/lib
   dodir /usr/lib/phoenix
   cp -RL --no-preserve=links ${S}/dist/bin/* ${D}/usr/lib/phoenix

   #fix permissions
   chown -R root.root ${D}/usr/lib/phoenix
   
    # Plugin path setup (rescuing the existent plugins)
    mv ${D}/usr/lib/${MY_PN}/plugins ${D}/usr/lib/${MY_PN}/plugins.temp
    dosym ../nsbrowser/plugins /usr/lib/${MY_PN}/
    mv ${D}/usr/lib/${MY_PN}/plugins.temp/* ${D}/usr/lib/${MY_PN}/plugins/
    rmdir ${D}/usr/lib/${MY_PN}/plugins.temp

   dobin ${FILESDIR}/phoenix
}

pkg_preinst() {
   # Remove the old plugins dir
   [ -d /usr/lib/phoenix/plugins ] && rm -r /usr/lib/phoenix/plugins
}
