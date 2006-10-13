# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim/kdepim-3.5.5-r1.ebuild,v 1.1 2006/10/13 18:06:37 flameeyes Exp $

inherit kde-dist

SRC_URI="${SRC_URI}
	mirror://gentoo/kdepim-3.5-patchset-02.tar.bz2"

DESCRIPTION="KDE PIM (Personal Information Management) apps: korganizer, kmail, knode..."

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="crypt gnokii pda"

DEPEND="~kde-base/kdebase-${PV}
	>=dev-libs/cyrus-sasl-2
	pda? ( app-pda/pilot-link dev-libs/libmal )
	gnokii? ( app-mobilephone/gnokii )
	crypt? ( >=app-crypt/gpgme-1.1.2-r1
		 <app-crypt/gnupg-1.9 )"
	# We use GnuPG 1.4.x for OpenPGP and 1.9 (via gpgme) for s/mime as upstream advises.
RDEPEND="${DEPEND}
	crypt? ( app-crypt/pinentry )"

PATCHES="${FILESDIR}/korganizer-${PV}-desktop.patch"

src_unpack() {
	kde_src_unpack
	# Call Qt 3 designer
	sed -i -e "s:\"designer\":\"${QTDIR}/bin/designer\":g" ${S}/libkdepim/kcmdesignerfields.cpp || die "sed failed"
}

src_compile() {
	local myconf="--with-sasl $(use_with gnokii)"
	use crypt && myconf="${myconf} --with-gpg=${ROOT}/usr/bin/gpg"

	kde_src_compile
}
