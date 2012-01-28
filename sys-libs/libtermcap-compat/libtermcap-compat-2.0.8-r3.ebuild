# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libtermcap-compat/libtermcap-compat-2.0.8-r3.ebuild,v 1.3 2012/01/28 14:56:58 phajdan.jr Exp $

# we only want this for binary-only packages, so we will only be installing
# the lib used at runtime; no headers and no files to link against

EAPI="2"

inherit eutils multilib toolchain-funcs

PATCHVER="2"

MY_P="termcap-${PV}"
DESCRIPTION="Compatibility package for old termcap-based programs"
HOMEPAGE="http://www.catb.org/~esr/terminfo/"
SRC_URI="http://www.catb.org/~esr/terminfo/termtypes.tc.gz
	mirror://gentoo/${MY_P}.tar.bz2
	mirror://gentoo/${MY_P}-patches-${PATCHVER}.tar.bz2"

LICENSE="GPL-2 LGPL-2 BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ppc ~sparc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	EPATCH_SOURCE="${WORKDIR}/patch"
	EPATCH_SUFFIX="patch"
	epatch "${EPATCH_SOURCE}"

	cd "${WORKDIR}"
	mv termtypes.tc termcap || die
	epatch "${EPATCH_SOURCE}"/tc.file
}

src_configure() {
	tc-export CC
}

src_install() {
	into /
	dolib.so libtermcap.so.${PV} || die
	dosym libtermcap.so.${PV} /$(get_libdir)/libtermcap.so.2 || die

	insinto /etc
	doins "${WORKDIR}"/termcap || die

	dodoc ChangeLog README
}
