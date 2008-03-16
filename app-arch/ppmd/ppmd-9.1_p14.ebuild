# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/ppmd/ppmd-9.1_p14.ebuild,v 1.3 2008/03/16 15:50:30 armin76 Exp $

inherit eutils flag-o-matic

PATCHV="${P##*_p}"
MY_P="${P%%_*}"
MY_P="${MY_P/-/_}"
MY_S=${PN}-i1
S=${WORKDIR}/${MY_S}
DESCRIPTION="PPM based compressor -- better behaved than bzip2"
HOMEPAGE="http://http.us.debian.org/debian/pool/main/p/ppmd/"
SRC_URI="http://http.us.debian.org/debian/pool/main/p/ppmd/${MY_P}.orig.tar.gz
	http://http.us.debian.org/debian/pool/main/p/ppmd/${MY_P}-${PATCHV}.diff.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="-alpha -amd64 ~hppa -ia64 ~mips ~ppc sparc x86"
IUSE=""

DEPEND=">=sys-apps/sed-4
	app-arch/gzip
	sys-devel/patch
	sys-devel/autoconf
	sys-devel/automake"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${WORKDIR}/${MY_P}-${PATCHV}.diff"
	epatch "${S}/${MY_P/_/-}/debian/patches"/*.patch
	mv "${S}/b/Makefile" "${S}" || die "no makefile found"
	epatch "${FILESDIR}/${PN}-p10-makefile.patch"
}

src_compile() {
	replace-flags "-O3" "-O2"
	append-flags "-fno-inline-functions -fno-exceptions -fno-rtti"
	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die "failed installing"
	doman "${S}/${MY_P/_/-}/debian/ppmd.1" || die "failed installing manpage"
	dodoc "${S}/read_me.txt" || die "failed installed readme"
}
