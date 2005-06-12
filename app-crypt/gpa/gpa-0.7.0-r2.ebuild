# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/gpa/gpa-0.7.0-r2.ebuild,v 1.10 2005/06/12 12:08:17 swegener Exp $

inherit eutils

DESCRIPTION="Standard GUI for GnuPG"
HOMEPAGE="http://www.gnupg.org/(en)/related_software/gpa/index.html"
SRC_URI="ftp://ftp.gnupg.org/gcrypt/alpha/gpa/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64 ~alpha"
IUSE="nls"

DEPEND=">=x11-libs/gtk+-2.0
	>=app-crypt/gnupg-1.2
	>=app-crypt/gpgme-0.9.0-r1
	nls? ( sys-devel/gettext )"

src_compile() {
	myconf=

	# By default gnupg puts gpgkeys_hkp in /usr/libexec/gnupg, so
	# check if it is in uncommon /usr/lib/gnupg, and change libexecdir
	# if so.  If we do not do this, hkp server types is not usable,
	# as gpa cannot find gpgkeys_hkp ...
	[ -f "/usr/lib/gnupg/gpgkeys_hkp" ] && myconf="--libexecdir=/usr/lib"

	GPGME_CONFIG=/usr/bin/gpgme-config \
	econf `use_enable nls` \
		${myconf} || die "econf failed"
	emake || die
}

src_install() {
	emake DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog README NEWS TODO
	insinto /usr/share/pixmaps/gpa
	doins gpa-logo-48x48.png pixmaps/*.xpm
	make_desktop_entry gpa "Gnu Privacy Assistant" gpa/gpa-logo-48x48.png Utility
}
