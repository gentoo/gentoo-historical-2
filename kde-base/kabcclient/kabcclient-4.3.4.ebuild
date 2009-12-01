# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kabcclient/kabcclient-4.3.4.ebuild,v 1.1 2009/12/01 10:00:01 wired Exp $

EAPI="2"

KMNAME="kdepim"
KMMODULE="console/${PN}"
inherit kde4-meta

DESCRIPTION="A command line client for accessing the KDE addressbook"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug +handbook"

src_install() {
	kde4-meta_src_install

	# work around NULL DT_RPATH in kabc2mutt
	dosym kabcclient ${PREFIX}/bin/kabc2mutt || die "couldn't symlink kabc2mutt to kabcclient"
}
