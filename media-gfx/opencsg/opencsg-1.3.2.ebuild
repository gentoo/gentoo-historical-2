# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/opencsg/opencsg-1.3.2.ebuild,v 1.1 2012/08/02 02:06:34 mattm Exp $

EAPI="2"

inherit qt4-r2

DESCRIPTION="The Constructive Solid Geometry rendering library"
HOMEPAGE="http://www.opencsg.org/"
SRC_URI="http://www.opencsg.org/OpenCSG-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

CDEPEND="media-libs/glew x11-libs/qt-core"
DEPEND="${CDEPEND} sys-devel/gcc"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/OpenCSG-${PV}"

src_unpack() {
	unpack ${A}

	/bin/rm -Rf "${S}"/glew
}

src_prepare() {
	# We actually want to install somthing
	cat << EOF >> src/src.pro
include.path=/usr/include
include.files=../include/*
target.path=/usr/lib
INSTALLS += target include
EOF

}

src_configure() {
	 eqmake4 "${S}"/src/src.pro
}
