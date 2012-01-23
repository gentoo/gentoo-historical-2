# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/leonidas-backgrounds/leonidas-backgrounds-11.0.0.2.ebuild,v 1.2 2012/01/23 16:00:35 ago Exp $

EAPI=3

inherit versionator rpm

SRC_PATH=development/15/source/SRPMS
FEDORA=12

MY_P="${PN}-$(get_version_component_range 1-3)"

DESCRIPTION="Fedora official background artwork"
HOMEPAGE="https://fedoraproject.org/wiki/F11_Artwork"

SRC_URI="mirror://fedora-dev/${SRC_PATH}/${PN}-$(replace_version_separator 3 -).fc${FEDORA}.src.rpm"

LICENSE="CCPL-Attribution-ShareAlike-2.0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="!x11-themes/fedora-backgrounds:11"
DEPEND=""

S="${WORKDIR}/${MY_P}"

SLOT="0"

src_unpack() {
	rpm_src_unpack

	# as of 2010-06-21 rpm.eclass does not unpack the further lzma
	# file automatically.
	unpack ./${MY_P}.tar.lzma
}

src_compile() { :; }
src_test() { :; }

src_install() {
	# This old version doesn't have a makefile to perform install.
	dodoc Credits || die

	insinto /usr/share/backgrounds/leonidas
	doins -r leonidas* landscape lion || die

	insinto /usr/share/gnome-background-properties
	doins desktop-*.xml || die
}
