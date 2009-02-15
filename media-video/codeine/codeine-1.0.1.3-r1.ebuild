# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/codeine/codeine-1.0.1.3-r1.ebuild,v 1.1 2009/02/15 17:10:09 carlo Exp $

inherit kde-functions multilib versionator toolchain-funcs

S="${WORKDIR}/${PN}-$(get_version_component_range 1-3)"

DESCRIPTION="Simple KDE frontend for xine-lib."
HOMEPAGE="http://kde-apps.org/content/show.php?content=17161"
SRC_URI="http://www.methylblue.com/codeine/${PN}-$(replace_version_separator 3 -).tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/xine-lib
	x11-libs/libXtst"

DEPEND="${RDEPEND}
	dev-util/scons"

need-kde 3.5

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-respect-cc.patch"
	epatch "${FILESDIR}/codeine-1.0.1.3-desktop-file.diff"
	epatch "${FILESDIR}/codeine-1.0.1.3-gcc43.diff"
}

src_compile() {
	local myconf="prefix=/usr"
	# Fix multilib issue.
	myconf="${myconf} libdir=/usr/$(get_libdir)
			qtlibs=${QTDIR}/$(get_libdir)"

	local sconsopts=$(echo "${MAKEOPTS}" | sed -e "s/.*\(-j[0-9]\+\).*/\1/")
	[[ ${MAKEOPTS/-s/} != ${MAKEOPTS} ]] && sconsopts="${sconsopts} -s"

	tc-export CC CXX

	scons configure ${myconf} \
		|| die "scons configure failed, if you report this please attach ${S}/configure.log"
	scons ${sconsopts} || die "scons make failed"
}

src_install() {
	DESTDIR="${D}" scons install || die
	dodoc README ChangeLog VERSION
}
