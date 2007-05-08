# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/bincimap/bincimap-1.3.3.ebuild,v 1.5 2007/05/08 23:03:35 genone Exp $

inherit eutils

DESCRIPTION="IMAP server for Maildir"
SRC_URI="http://www.bincimap.org/dl/tarballs/1.3/${P}.tar.bz2"
HOMEPAGE="http://www.bincimap.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="ssl"

DEPEND="virtual/libc
	ssl? ( dev-libs/openssl )"

RDEPEND="${DEPEND}
	sys-process/daemontools
	sys-apps/ucspi-tcp
	net-mail/checkpassword"

PROVIDE="virtual/imapd"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch ${FILESDIR}/${P}-gentoo.diff
}

src_compile() {
	econf $(use_enable ssl) --sysconfdir=/etc/bincimap \
		--datadir=/usr/share/doc/${PF} \
		--localstatedir=/etc/bincimap || die
	emake || die
}

src_install () {
	make DESTDIR=${D} prefix=/usr install || die
	keepdir /var/log/bincimap || die
	if use ssl; then
		keepdir /var/log/bincimap-ssl || die
	fi

	# backward compatibility
	dosym /etc/bincimap/service/bincimap /etc/bincimap/service/imap
	dosym /etc/bincimap/service/bincimaps /etc/bincimap/service/imaps

	# rename
	mv ${D}/etc/xinetd.d/{xinetd-bincimap,bincimap}
	mv ${D}/etc/xinetd.d/{xinetd-bincimaps,bincimaps}
}

pkg_postinst() {
	elog "To start bicimap at boot you have to enable the /etc/init.d/svscan rc file"
	elog "and create the following link:"
	elog "ln -sf /etc/bincimap/service/bincimap /service/"
	elog

	if use ssl; then
		elog "If you want to use ssl connections, create the following link instead of above link."
		elog "ln -sf /etc/bincimap/service/bincimaps /service/"
		elog
		elog "And this command will setup bincimap-ssl on your system."
		elog "emerge --config =${CATEGORY}/${PF}"
		elog
	fi

	#elog "NOTE: Default Maildir path is '~/.maildir'. If you want to modify it, "
	#elog "edit /etc/bincimap/bincimap.conf"
	#elog
}

pkg_config() {
	if use ssl; then
		local pemfile=/etc/bincimap/bincimap.pem
		if [ ! -f $pemfile ]; then
			echo "Creating a self-signed ssl-cert:"
			/usr/bin/openssl req -new -x509 -nodes -out $pemfile -days 366 -keyout $pemfile
			chmod 640 $pemfile

			einfo "If You want to have a signed cert, do the following:"
			einfo "openssl req -new -nodes -out req.pem \\"
			einfo "-keyout $pemfile"
			einfo "chmod 640 $pemfile"
			einfo "Send req.pem to your CA to obtain signed_req.pem, and do:"
			einfo "cat signed_req.pem >> $pemfile"
		fi
	fi
}
