# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/pdv/pdv-1.5.1-r1.ebuild,v 1.7 2006/01/21 01:51:38 vanquirius Exp $

inherit eutils

DESCRIPTION="build a self-extracting and self-installing binary package"
HOMEPAGE="http://pdv.sourceforge.net/"
SRC_URI="mirror://sourceforge/pdv/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~hppa ~ppc ~x86"
IUSE="nomotif"

DEPEND=">=sys-devel/autoconf-2.58
	sys-devel/automake
	!nomotif? ( x11-libs/openmotif )
	!nomotif? ( || (
	( >=x11-libs/libX11-1.0.0
	>=x11-libs/libXt-1.0.0
	>=x11-libs/libXext-1.0.0
	>=x11-libs/libXp-1.0.0 )
	virtual/x11
	) )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# fix a size-of-variable bug
	epatch "${FILESDIR}"/${P}-opt.patch
	# fix a free-before-use bug
	epatch "${FILESDIR}"/${P}-early-free.patch
	# fix a configure script bug
	epatch "${FILESDIR}"/${P}-x-config.patch
}

src_compile() {
	# re-build configure script since patch was applied to configure.in
	cd "${S}"/X11
	export WANT_AUTOCONF=2.5
	aclocal
	automake -a -c
	autoconf

	cd "${S}"
	local myconf=""
	use nomotif && myconf="--without-x" # configure script is broken, cant use use_with
	econf ${myconf} || die
	emake || die
}

src_install() {
	dobin pdv pdvmkpkg || die
	doman pdv.1 pdvmkpkg.1
	if ! use nomotif ; then
		dobin X11/xmpdvmkpkg || die
		doman xmpdvmkpkg.1 || die
	fi
	dodoc AUTHORS ChangeLog NEWS README pdv.lsm
}
