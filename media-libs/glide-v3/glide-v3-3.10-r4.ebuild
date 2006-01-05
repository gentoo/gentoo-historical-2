# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/glide-v3/glide-v3-3.10-r4.ebuild,v 1.10 2006/01/05 18:38:37 spyderous Exp $

# NOTE:  Do NOT build this with optimizations, as it will make this package
#        unstable!!!!

inherit eutils

S=${WORKDIR}/${PN/-v3/3x}
DESCRIPTION="Hardware support for the voodoo3, voodoo4 and voodoo5"
HOMEPAGE="http://glide.sourceforge.net/"
SRC_URI="mirror://gentoo/glide3x-${PV}.tar.gz
	mirror://gentoo/swlibs-${PV}.tar.gz
	mirror://gentoo/${P}-fixes.patch.bz2"
# check for future updates here
# http://telia.dl.sourceforge.net/mirrors/slackware/slackware-8.0/contrib/contrib-sources/3dfx/voodoo4_voodoo5/

LICENSE="3DFX"
SLOT="0"
KEYWORDS="x86 -sparc alpha"
IUSE="voodoo3 3dnow"

RDEPEND="|| ( ( x11-libs/libXxf86dga
			x11-libs/libXxf86vm
		)
		virtual/x11
	)"
DEPEND="${RDEPEND}
	|| ( ( x11-proto/xf86dgaproto
			x11-proto/xf86vidmodeproto
			x11-libs/libXt
		)
		virtual/x11
	)
	>=sys-devel/automake-1.4
	>=sys-devel/autoconf-2.57
	>=sys-devel/libtool-1.3.3
	>=sys-devel/m4-1.4
	>=sys-apps/sed-4
	>=dev-lang/perl-5.005"

src_unpack() {
	unpack ${A}

	cd ${WORKDIR}
	chmod +x swlibs/include/make/ostype
	cd ${S} ; ln -fs ${WORKDIR}/swlibs swlibs
	cd ${S}/h3/minihwc ; ln -fs linhwc.c.dri linhwc.c
	cd ${S}/h3/glide3/src ; ln -fs gglide.c.dri gglide.c
	ln -fs gsst.c.dri gsst.c ; ln -fs glfb.c.dri glfb.c

	cd ${S}
	epatch ${WORKDIR}/${P}-fixes.patch
	epatch ${FILESDIR}/${P}-2.6-headers-fix.patch
	export WANT_AUTOMAKE="1.4" WANT_AUTOCONF="2.5"
	libtoolize -f && aclocal && automake && autoconf
}

src_compile() {
	local compilefor=
	use voodoo3 \
		&& compilefor="h3" \
		|| compilefor="h5"
	mkdir build
	cd build
	../configure \
		--prefix=/usr \
		--enable-fx-glide-hw=${compilefor} \
		--enable-fx-dri-build \
		`use_enable 3dnow amd3d` \
			|| die "configure failed"

	# On alpha at least, glide incorrectly guesses 486 processor.
	# Fixup the makefiles.
	if use alpha; then
		find . -type f | xargs grep -le -m486 | \
			xargs sed -i -e "s|-m486|${CFLAGS}|"
	fi

	make -f makefile.autoconf all || die "build.3dfx failed"
}

src_install() {
	cd ${S}/build
	make -f makefile.autoconf DESTDIR="${D}" install || die "install failed"

	dodir /usr/X11R6/lib
	dosym /usr/lib/libglide3.so.${PV}.0 /usr/X11R6/lib/libglide3.so
}
