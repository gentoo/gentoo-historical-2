# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/ppmd/ppmd-9.1.ebuild,v 1.9 2004/05/04 13:58:33 kloeri Exp $

inherit eutils flag-o-matic

IUSE=""

PATCHV="7"
MY_P=${P/-/_}
MY_S=${PN}-i1
S=${WORKDIR}/${MY_S}
DESCRIPTION="PPM based compressor -- better behaved than bzip2"
HOMEPAGE="http://http.us.debian.org/debian/pool/main/p/ppmd/"
SRC_URI="http://http.us.debian.org/debian/pool/main/p/ppmd/${MY_P}.orig.tar.gz
	http://http.us.debian.org/debian/pool/main/p/ppmd/${MY_P}-${PATCHV}.diff.gz"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~x86 ~ppc ~sparc alpha ~hppa ~mips amd64 ~ia64"

DEPEND=">=sys-apps/sed-4
	app-arch/gzip
	sys-devel/patch
	sys-devel/autoconf
	sys-devel/automake"

RDEPEND="app-arch/gzip"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/${MY_P}-${PATCHV}.diff
	chmod +x ${S}/configure
	sed -i 3q Makefile.am
	autoreconf --force || die
}

src_compile() {
	replace-flags "-O3" "-O2"
	econf || die
	emake || die
}

src_install() {
	einstall || die
	doman ${S}/PPMd.1
	dodoc ${S}/read_me.txt
}
