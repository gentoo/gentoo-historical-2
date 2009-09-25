# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/openfoam-src/openfoam-src-1.5_p20090311.ebuild,v 1.2 2009/09/25 09:30:00 flameeyes Exp $

EAPI="2"

inherit eutils versionator multilib

MY_PN="OpenFOAM"
MY_PV=$(get_version_component_range 1-2)
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="OpenFOAM - sources"
HOMEPAGE="http://www.opencfd.co.uk/openfoam/"
SRC_URI="mirror://sourceforge/foam/${MY_P}.General.gtgz -> ${MY_P}.General.tgz
	http://omploader.org/vMWRlMQ/${MY_PN}-git-${PVR}.patch
	http://omploader.org/vMWRlMA/${MY_P}-svn.patch
	mirror://gentoo/${MY_P}-compile-2.patch.bz2"

LICENSE="GPL-2"
SLOT="1.5"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( =sci-libs/openfoam-meta-${MY_PV}* =sci-libs/openfoam-${MY_PV}* =sci-libs/openfoam-bin-${MY_PV}* )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}
INSDIR="/usr/$(get_libdir)/${MY_PN}/${MY_P}"

src_prepare() {
	epatch "${DISTDIR}"/${MY_P}-compile-2.patch.bz2
	epatch "${DISTDIR}"/${MY_P}-svn.patch
	epatch "${DISTDIR}"/${MY_PN}-git-${PVR}.patch
	epatch "${FILESDIR}"/${MY_P}-ggi.patch
}

src_compile() {
	source ${INSDIR}/etc/bashrc
	wcleanLnIncludeAll || die "could not clean lnInclude dirs"
}
src_install() {
	insinto ${INSDIR}/src
	doins -r src/*

	insinto ${INSDIR}/applications
	doins -r applications/*
}
