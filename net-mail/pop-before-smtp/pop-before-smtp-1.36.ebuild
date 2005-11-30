# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/pop-before-smtp/pop-before-smtp-1.36.ebuild,v 1.1 2004/11/05 13:59:29 ticho Exp $

DESCRIPTION="a simple daemon to allow email relay control based on successful POP or IMAP logins"
HOMEPAGE="http://popbsmtp.sourceforge.net"
SRC_URI="mirror://sourceforge/popbsmtp/${P}.tar.gz"

LICENSE="GPL-2 BSD Artistic"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-perl/File-Tail
	dev-perl/Time-HiRes
	dev-perl/Net-Netmask
	dev-perl/TimeDate
	dev-perl/Unix-Syslog"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}

	# enable syslog
	sed -i \
		-e "/^=cut #============================= syslog ===========================START=$/d" \
		-e "/^=cut #============================= syslog =============================END=$/d" \
		pop-before-smtp-conf.pl \
			|| die "sed pop-before-smtp-conf.pl failed"
}

src_install() {
	dosbin pop-before-smtp || die "dosbin failed"
	dodoc README ChangeLog TODO contrib/README.QUICKSTART
	insinto /etc
	doins pop-before-smtp-conf.pl || die "doins failed"
	exeinto /etc/init.d
	newexe "${FILESDIR}/pop-before-smtp.init" pop-before.smtp \
		|| die "newexe failed"
}
