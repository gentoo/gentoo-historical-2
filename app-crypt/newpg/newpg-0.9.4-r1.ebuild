# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/newpg/newpg-0.9.4-r1.ebuild,v 1.10 2004/07/11 17:41:18 slarti Exp $

DESCRIPTION="NewPG is the S/MIME variant of GnuPG which does also include the gpg-agent, useful even for GnuPG"
SRC_URI="ftp://ftp.gnupg.org/gcrypt/alpha/aegypten/${P}.tar.gz"
HOMEPAGE="http://www.gnupg.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"
IUSE="nls"

DEPEND="dev-lang/perl
	<=dev-libs/libksba-0.9
	<=dev-libs/libgcrypt-1.1.90
	!<dev-libs/libgcrypt-1.1.8
	dev-libs/pth"
RDEPEND="nls? ( sys-devel/gettext )
	app-crypt/pinentry"

src_compile() {
	local myconf
	use nls || myconf="${myconf} --disable-nls"

	#set the default pinentry program to a sensible location
	if [ -x /usr/bin/pinentry-qt ]; then
		myconf="${myconf} --with-pinentry-pgm=/usr/bin/pinentry-qt"
	else
		if [ -x /usr/bin/pinentry-gtk ]; then
			myconf="${myconf} --with-pinentry-pgm=/usr/bin/pinentry-gtk"
		fi
	fi

	econf ${myconf} --disable-dependency-tracking \
		--exec-prefix=/usr || die "econf failed"
	make || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README THANKS TODO VERSION

	chmod +s "${D}/usr/bin/gpgsm"
}

pkg_postinst() {
	einfo "gpgsm is installed SUID root to make use of protected memory space"
	einfo "This is needed in order to have a secure place to store your passphrases,"
	einfo "etc. at runtime but may make some sysadmins nervous"
}
