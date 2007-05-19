# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/dash/dash-0.5.3.7-r1.ebuild,v 1.1 2007/05/19 09:31:44 uberlord Exp $

inherit autotools eutils flag-o-matic toolchain-funcs

DEB_PV=${PV%.*}
DEB_PATCH=${PV##*.}
DEB_PF="${PN}_${DEB_PV}-${DEB_PATCH}"
MY_P="${PN}-${DEB_PV}"

DESCRIPTION="DASH is a direct descendant of the NetBSD version of ash (the
Almquist SHell) and is POSIX compliant"
HOMEPAGE="http://gondor.apana.org.au/~herbert/dash/"
SRC_URI="http://gondor.apana.org.au/~herbert/dash/files/${PN}-${DEB_PV}.tar.gz \
	mirror://debian/pool/main/d/dash/${DEB_PF}.diff.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="libedit static"

DEPEND="libedit? ( dev-libs/libedit )"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	epatch "${WORKDIR}/${DEB_PF}".diff

	cd "${S}"
	local f=
	for f in debian/diff/* ; do
		epatch "${f}"
	done

	# Below patch sorts the builtincmd structure correctly when LC_ALL isn't C
	epatch "${FILESDIR}/${MY_P}"-sort-locale.patch

	# May as well, as the debian patches force this anyway
	eautoreconf
}

src_compile() {
	local myconf=

	use libedit && myconf="${myconf} --with-libedit"
	use static && append-ldflags -static
	export CC="$(tc-getCC)"

	econf ${myconf} || die "econf failed"

	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	exeinto /bin
	newexe src/dash dash
	newman src/dash.1 dash.1
	dodoc COPYING ChangeLog
}
