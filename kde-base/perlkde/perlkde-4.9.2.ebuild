# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/perlkde/perlkde-4.9.2.ebuild,v 1.1 2012/10/02 18:12:13 johu Exp $

EAPI=4

inherit kde4-base

DESCRIPTION="KDE Perl bindings"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="akonadi attica debug kate okular semantic-desktop test"

RDEPEND="
	>=dev-lang/perl-5.10.1
	$(add_kdebase_dep perlqt)
	$(add_kdebase_dep smokekde 'attica?,kate?,okular?,semantic-desktop=')
	semantic-desktop? ( >=dev-libs/soprano-2.8.0 )
"
DEPEND="${RDEPEND}
	test? ( dev-perl/List-MoreUtils )
"

# Split from kdebindings-perl in 4.7
add_blocker kdebindings-perl

PATCHES=( "${FILESDIR}/${PN}-4.7.2-vendor.patch" )

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with akonadi)
		$(cmake-utils_use_with akonadi KdepimLibs)
		$(cmake-utils_use_with attica LibAttica)
		$(cmake-utils_use_disable kate)
		$(cmake-utils_use_with okular)
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		$(cmake-utils_use_with semantic-desktop Soprano)
	)
	kde4-base_src_configure
}
