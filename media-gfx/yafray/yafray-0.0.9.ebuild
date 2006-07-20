# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/yafray/yafray-0.0.9.ebuild,v 1.1 2006/07/20 13:38:46 lu_zero Exp $

inherit eutils python multilib

DESCRIPTION="Yet Another Free Raytracer"
HOMEPAGE="http://www.yafray.org/"
SRC_URI="http://www.yafray.org/sec/2/downloads/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="openexr"

RDEPEND="media-libs/jpeg
	sys-libs/zlib"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-3.3
	>=sys-apps/sed-4
	dev-util/scons"

export WANT_AUTOMAKE="1.7"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-scons.patch
	epatch ${FILESDIR}/${P}-libdir.patch
	# Dirty hack for a dirty buildsystem.
	sed -i -e "s:-O3:${CXXFLAGS} -fsigned-char:g" *-settings.py
}

src_compile() {
	local exr_path=""
	use openexr && exr_path="/usr"

	scons ${MAKEOPTS} prefix="/usr" \
					  libdir="/$(get_libdir)" 
					  exr_path="$exr_path" || die
}

src_install() {
	scons prefix="/usr" destdir="${D}" libdir="/$(get_libdir)" install || die

	find ${D} -name .sconsign -exec rm \{\} \;
	dodoc AUTHORS 		|| die "dodoc failed"
	dohtml doc/doc.html || die "dohtml failed"
}
