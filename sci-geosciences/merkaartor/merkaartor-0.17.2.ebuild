# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/merkaartor/merkaartor-0.17.2.ebuild,v 1.3 2011/06/10 15:31:33 scarabeus Exp $

EAPI=4

REDMINE_HASH="253"
[[ ${PV} == 9999 ]] && SCM_ECLASS=git-2
EGIT_REPO_URI="git://gitorious.org/merkaartor/main.git"
EGIT_PROJECT=${PN}
inherit multilib qt4-r2 ${SCM_ECLASS}

DESCRIPTION="A Qt4 based map editor for the openstreetmap.org project"
HOMEPAGE="http://www.merkaartor.be"
[[ ${PV} == 9999 ]] || SRC_URI="http://merkaartor.be/attachments/download/${REDMINE_HASH}/merkaartor-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
[[ ${PV} == 9999 ]] || KEYWORDS="~amd64 ~x86"
IUSE="debug exif gps nls libproxy"

QT_MINIMAL="4.7.2"
DEPEND="
	>=sci-libs/gdal-1.6.0
	>=sci-libs/proj-4.6
	>=x11-libs/qt-gui-${QT_MINIMAL}:4
	>=x11-libs/qt-svg-${QT_MINIMAL}:4
	>=x11-libs/qt-webkit-${QT_MINIMAL}:4
	exif? ( media-gfx/exiv2 )
	gps? ( >=sci-geosciences/gpsd-2.92 )
	libproxy? ( net-libs/libproxy )
"
RDEPEND="${DEPEND}"

DOCS="AUTHORS CHANGELOG HACKING"

PATCHES=(
	"${FILESDIR}/${PV}-includes.patch"
	"${FILESDIR}/${PV}-libproxy.patch"
)

merkaartor_use() {
	local useflag=${1}
	[[ -z ${useflag} ]] && die "No useflag specified"
	if use ${useflag}; then
		echo "1"
	else
		echo "0"
	fi
}

src_configure() {
	local myconf
	myconf+=" RELEASE=1 ZBAR=0" # deps not in main tree so hard-disable
	myconf+=" GEOIMAGE=$(${PN}_use exif)"
	myconf+=" GPSDLIB=$(${PN}_use gps)"
	myconf+=" LIBPROXY=$(${PN}_use libproxy)"
	myconf+=" NODEBUG=$(use debug && echo "0" || echo "1")" # inverse logic
	myconf+=" NOUSEWEBKIT=0" # fails to link if disabled, upstream needs to fix

	if use nls; then
		lrelease src/src.pro || die "lrelease failed"
	fi

	eqmake4 Merkaartor.pro LIBDIR=/usr/$(get_libdir) PREFIX=/usr/ ${myconf}
}
