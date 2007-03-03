# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgcrypt/libgcrypt-1.2.1-r1.ebuild,v 1.6 2007/03/03 22:58:06 genone Exp $

inherit eutils

DESCRIPTION="general purpose crypto library based on the code used in GnuPG"
HOMEPAGE="http://www.gnupg.org/"
SRC_URI="mirror://gnupg/libgcrypt/${P}.tar.gz
	mirror://gentoo/${PN}-1.2.1-patches.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="nls"

DEPEND="dev-libs/libgpg-error"
RDEPEND="nls? ( sys-devel/gettext )
	dev-libs/libgpg-error"

src_unpack() {
	unpack ${A}
	epunt_cxx
	epatch ${WORKDIR}/${P}-GNU-stack-fix.patch

	# Fix info file to make subsequent index entry work
	cd ${S}/doc
	epatch ${WORKDIR}/${P}-info-entry-fix.patch
}

src_compile() {
	econf $(use_enable nls) --disable-dependency-tracking --with-pic || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS BUGS ChangeLog NEWS README* THANKS TODO VERSION

	# backwards compat symlinks
	dosym libgcrypt.so.11 /usr/lib/libgcrypt.so.7
}
