# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/winex/winex-20030328.ebuild,v 1.6 2003/06/24 18:22:31 coronalvr Exp $

inherit base

DESCRIPTION="distribution of Wine with enhanced DirectX for gaming"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	mirror://gentoo/${P}-fake_windows.tar.bz2
	mirror://gentoo/${P}-misc.tar.bz2
	mirror://gentoo/${P}-xopenfont.patch"
HOMEPAGE="http://www.transgaming.com/"

SLOT="0"
KEYWORDS="~x86 -ppc -sparc"
LICENSE="Aladdin"
IUSE="cups opengl"

DEPEND="sys-devel/gcc
	sys-devel/flex
	dev-util/yacc
	>=sys-libs/ncurses-5.2
	>=media-libs/freetype-2.0.0
	X? ( 	virtual/x11 
		dev-lang/tcl 
		dev-lang/tk ) 
	opengl? ( virtual/opengl )
	cups? ( net-print/cups )
	!app-emulation/winex-transgaming"

S=${WORKDIR}/wine

src_unpack() {
	base_src_unpack
	cd ${S}
	epatch ${DISTDIR}/${P}-xopenfont.patch
}

src_compile() {
	cd ${S}
	local myconf

	use opengl && myconf="--enable-opengl" || myconf="--disable-opengl"
	[ -z $DEBUG ] && myconf="$myconf --disable-trace --disable-debug" || myconf="$myconf --enable-trace --enable-debug"

	# use the default setting in ./configure over the /etc/make.conf setting
	unset CFLAGS CXXFLAGS
	
        # patching winex to not compile wcmd and winhelp
	epatch ${FILESDIR}/winex-20030328.patch

	./configure --prefix=/usr/lib/winex \
		--sysconfdir=/etc/winex \
		--host=${CHOST} \
		--enable-curses \
		--with-x \
		${myconf} || die "configure failed"

	# Fixes a winetest issue
	cd ${S}/programs/winetest
	cp Makefile 1
	sed -e 's:wine.pm:include/wine.pm:' 1 > Makefile

	# This persuades wineshelllink that "winex" is a better loader :)
	cd ${S}/tools
	cp wineshelllink 1
	sed -e 's/\(WINE_LOADER=\)\(\${WINE_LOADER:-wine}\)/\1winex/' 1 > wineshelllink

	cd ${S}	
	make depend all || die "make depend all failed"
	cd ${S}/programs
	make || die "make died"
}

src_install () {
	local WINEXMAKEOPTS="prefix=${D}/usr/lib/${PN}"
	
	# Installs winex to ${D}/usr/lib/${PN}
	cd ${S}
	make ${WINEXMAKEOPTS} install || die "make install failed"
        cd ${S}/programs
	make ${WINEXMAKEOPTS} install || die "make install failed"

	dodir /usr/bin

	# Creates /usr/lib/winex/.data with fake_windows in it
	# This is needed for ~/.winex initialization by our 
	# winex wrapper script
	dodir /usr/lib/winex/.data
	cd ${D}/usr/lib/winex/.data
	tar jxvf ${DISTDIR}/${P}-fake_windows.tar.bz2
	chown root:root fake_windows/ -R

	# moving the wrappers to bin/
	insinto /usr/bin
	dobin ${WORKDIR}/regedit-winex ${WORKDIR}/winex

	### Set up the remaining files
	cd ${S}

	# copying the winedefault.reg into .data
	insinto /usr/lib/winex/.data
	doins winedefault.reg ${WORKDIR}/config

	# Set up this dynamic data
	insinto /usr/lib/wine/.data/fake_windows/Windows
	doins documentation/samples/system.ini
	doins documentation/samples/generic.ppd
 
	### Misc tasks
	# Take care of the documentation
	cd ${S}
	dodoc ANNOUNCE AUTHORS BUGS ChangeLog DEVELOPERS-HINTS LICENSE README

	# Manpage setup
	mv ${D}/usr/lib/${PN}/man/man1/wine.1 ${D}/usr/lib/${PN}/man/man1/${PN}.1
	doman ${D}/usr/lib/${PN}/man/man1/${PN}.1
	rm ${D}/usr/lib/${PN}/man/man1/${PN}.1
	
	# Remove the executable flag from those libraries.
	cd ${D}/usr/lib/${PN}/bin
	chmod a-x *.so
}

pkg_postinst() {
	einfo "Use /usr/bin/winex to start winex."
	einfo "This is a wrapper-script which will take care of everything"
	einfo "else. If you have bugs, enhancements or patches"
	einfo "send a bug report and assign it to wine@gentoo.org"
	einfo ""
	einfo "Manpage has been installed to the system."
	einfo "\"man winex\" should show it."
}
