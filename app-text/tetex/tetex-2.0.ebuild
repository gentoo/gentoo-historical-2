# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/tetex/tetex-2.0.ebuild,v 1.2 2003/02/03 05:37:56 satai Exp $

inherit flag-o-matic

IUSE="ncurses X libwww png"
S=${WORKDIR}/tetex-src-${PV}

TETEXSRC="tetex-src-${PV}.tar.gz"
TEXMFSRC="tetex-texmfsrc-${PV}.tar.gz"
TEXMF="tetex-texmf-${PV}.tar.gz"

DESCRIPTION="teTeX is a complete TeX distribution"
SRC_URI="ftp://cam.ctan.org/tex-archive/systems/unix/teTeX/2.0/distrib/${TETEXSRC}
         ftp://cam.ctan.org/tex-archive/systems/unix/teTeX/2.0/distrib/${TEXMFSRC}
         ftp://cam.ctan.org/tex-archive/systems/unix/teTeX/2.0/distrib/${TEXMF}"
HOMEPAGE="http://tug.cs.umb.edu/tetex/"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
SLOT="0"
LICENSE="GPL-2"

DEPEND="sys-apps/ed
	sys-libs/zlib 
	X? ( virtual/x11 )
	png? ( >=media-libs/libpng-1.2.1 )
	ncurses? ( sys-libs/ncurses )
	libwww? ( >=net-libs/libwww-5.3.2-r1 )"

RDEPEND=">=sys-devel/perl-5.2
	dev-util/dialog"


src_unpack() {
	unpack ${TETEXSRC}

	cd ${S}
	#patch -p1 < ${FILESDIR}/${PF}-gentoo.diff
	
	mkdir ${S}/texmf
	cd ${S}/texmf
	umask 022
	pwd
	einfo "Unpacking ${TEXMFSRC}"
	tar --no-same-owner -xzf ${DISTDIR}/${TEXMFSRC} || die

	einfo "Unpacking ${TEXMF}"
	tar --no-same-owner -xzf ${DISTDIR}/${TEXMF} || die

	# Do not run config stuff
	cd ${WORKDIR}
	cd ${S}
	patch -p0 < ${FILESDIR}/${P}-dont-run-config.diff || die

	# Fix for dvips to print directly.
	#patch -p1 < ${FILESDIR}/teTeX-1.0-dvips.diff || die

}

src_compile() {

	local myconf=""
	use X \
		&& myconf="--with-x" \
		|| myconf="--without-x"

	use libwww \
		&& myconf="${myconf} --with-system-wwwlib \
		                     --with-libwww-include=/usr/include/w3c-libwww"

	use png \
		&& myconf="${myconf} --with-system-pnglib"

	
	use ncurses \
		&& myconf="${myconf} --with-system-ncurses"

	
	# Does it make sense to compile the included libwww with mysql ?

	./configure --host=${CHOST} \
		--prefix=/usr \
		--bindir=/usr/bin \
		--datadir=/usr/share \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--datadir=${S} \
		--without-texinfo \
		--without-dialog \
		--with-system-zlib \
		--disable-multiplatform \
		--with-epsfwin \
		--with-mftalkwin \
		--with-regiswin \
		--with-tektronixwin \
		--with-unitermwin \
		--with-ps=gs \
		--enable-ipc \
		--with-etex \
		${myconf} || die

	make texmf=/usr/share/texmf || die
}

src_install() {

	dodir /usr/share/
    # Install texmf files
	einfo "Installing texmf..."
    cp -Rv texmf ${D}/usr/share
		
	make prefix=${D}/usr \
		bindir=${D}/usr/bin \
		datadir=${D}/usr/share \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		texmf=${D}/usr/share/texmf \
		install || die

	dodoc PROBLEMS README
	docinto texk
	dodoc texk/ChangeLog texk/README
	docinto kpathesa
	cd ${S}/texk/kpathsea
	dodoc README* NEWS PROJECTS HIER
	docinto dviljk
	cd ${S}/texk/dviljk
	dodoc AUTHORS README NEWS
	docinto dvipsk
	cd ${S}/texk/dvipsk
	dodoc AUTHORS ChangeLog INSTALLATION README
	docinto makeindexk
	cd ${S}/texk/makeindexk
	dodoc CONTRIB COPYING NEWS NOTES PORTING README
	docinto ps2pkm
	cd ${S}/texk/ps2pkm
	dodoc ChangeLog CHANGES.type1 INSTALLATION README* 
	docinto web2c
	cd ${S}/texk/web2c
	dodoc AUTHORS ChangeLog NEWS PROJECTS README
	docinto xdvik
	cd ${S}/texk/xdvik
	dodoc BUGS FAQ README* 

	#fix for conflicting readlink binary:
	rm -f ${D}/bin/readlink
	rm -f ${D}/usr/bin/readlink
	#add /var/cache/fonts directory
	dodir /var/cache/fonts

	#fix for lousy upstream permisssions on /usr/share/texmf files
	#NOTE: do not use fowners, as its not recursive ...
	einfo "Fixing permissions..."
	chown -R root.root ${D}/usr/share/texmf
}

pkg_postinst() {

	if [ $ROOT = "/" ]
	then
		einfo "Configuring teTeX..."
		mktexlsr &>/dev/null
		texlinks &>/dev/null
		texconfig init &>/dev/null
		texconfig confall &>/dev/null
		texconfig font vardir /var/cache/fonts &>/dev/null
		einfo "Generating format files..."
		fmtutil --missing &>/dev/null # This should generate all missing fmt files.
		echo
		einfo "Use 'texconfig font rw' to allow all users to generate fonts."
		echo
	fi
}

