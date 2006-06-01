# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/certmanager/certmanager-3.5.2-r1.ebuild,v 1.9 2006/06/01 04:49:27 tcort Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE certificate manager gui."
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="$(deprange 3.5.0 $MAXKDEVER kde-base/libkpgp)
	$(deprange 3.5.0 $MAXKDEVER kde-base/libkdenetwork)
	>=app-crypt/gpgme-1.1.2-r1
	<app-crypt/gnupg-1.9"
	# We use GnuPG 1.4.x for OpenPGP and 1.9 (via gpgme) for s/mime as upstream advises.
#RDEPEND="${DEPEND}
#	>=app-crypt/dirmngr-0.9.3"

KMCOPYLIB="libqgpgme libkdenetwork/qgpgme/"
KMEXTRACTONLY="libkdenetwork/
	libkpgp/
	libkdepim/"

KMEXTRA="doc/kleopatra
	doc/kwatchgnupg"

src_compile() {
	myconf="--with-gpg=${ROOT}/usr/bin/gpg"
	kde_src_compile
}
