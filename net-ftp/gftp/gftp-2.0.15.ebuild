# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/gftp/gftp-2.0.15.ebuild,v 1.3 2003/11/10 21:12:04 foser Exp $

IUSE="nls gtk gtk2 ssl"
S=${WORKDIR}/${P}
DESCRIPTION="Gnome based FTP Client"
SRC_URI="http://www.gftp.org/${P}.tar.bz2"
HOMEPAGE="http://www.gftp.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc"

DEPEND="virtual/x11
	ssl? ( dev-libs/openssl )
	gtk? (
		gtk2? ( >=x11-libs/gtk+-2 ) : ( =x11-libs/gtk+-1.2* ) )
	!gtk? ( sys-libs/readline
		sys-libs/ncurses
		=dev-libs/glib-1.2* )"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	local myconf

	use nls \
		&& myconf="--enable-nls" \
		|| myconf="--disable-nls"

	# do not use enable-{gtk20,gtkport} they are not recognized
	# and will disable building the gtkport alltogether
	if [ -n "`use gtk`" ]
	then
		einfo "gtk+ enabled"
		use gtk2 \
			&& einfo "gtk2 enabled" \
			|| myconf="${myconf} --disable-gtk20"
	else
		einfo "gtk+ and gtk2 disabled"
		myconf="${myconf} --disable-gtkport --disable-gtk20"
	fi

	use ssl \
		&& myconf="${myconf}" \
		|| myconf="${myconf} --disable-ssl"

	econf ${myconf} || die
	emake || die
}

src_install() {
	einstall || die

	dodoc COPYING ChangeLog AUTHORS README* THANKS \
		TODO docs/USERS-GUIDE NEWS

}
