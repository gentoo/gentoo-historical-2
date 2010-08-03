# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/qpopper/qpopper-4.0.14.ebuild,v 1.2 2010/08/03 21:00:34 hwoarang Exp $

EAPI="2"
#inherit eutils flag-o-matic ssl-cert
inherit eutils ssl-cert

MY_P=${PN}${PV}

DESCRIPTION="A POP3 Server"
HOMEPAGE="http://www.eudora.com/products/unsupported/qpopper/index.html"
SRC_URI="ftp://ftp.qualcomm.com/eudora/servers/unix/popper/${MY_P}.tar.gz"

LICENSE="qpopper ISOC-rfc"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="debug gdbm mailbox pam ssl xinetd apop"

DEPEND="virtual/mta
	xinetd? ( virtual/inetd )
	gdbm? ( sys-libs/gdbm )
	!gdbm? ( ~sys-libs/db-1.85 )
	pam? (
		>=sys-libs/pam-0.72
		>=net-mail/mailbase-0.00-r8
	)
	ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	use apop && enewuser pop
}

src_prepare() {
	# Test dirs are full of binary craft. Drop it.
	rm -rf test/ ./mmangle/test ./popper/.nfsF8E5
	epatch "${FILESDIR}/${PN}-4.0.14-parallel-build.patch"
	sed -i -e 's:-o popauth:& ${LDFLAGS}:' popper/Makefile.in
}

src_configure() {
#	append-flags -Wa,--noexecstack

	econf \
		$(use_enable !xinetd standalone) \
		$(use_enable debug debugging)   \
		$(use_with ssl openssl)         \
		$(use_with gdbm)                \
		$(use_with pam pam pop3)        \
		$(use_enable apop apop /etc/pop.auth) \
		$(use_enable mailbox home-dir-mail Mailbox) \
		--enable-shy \
		--enable-popuid=pop \
		--enable-log-login \
		--enable-specialauth \
		--enable-log-facility=LOG_MAIL \
		--enable-uw-kludge-flag

	if ! use gdbm; then
		sed -i -e 's|#define HAVE_GDBM_H|//#define HAVE_GDBM_H|g' config.h || die "sed failed"
	fi
}

src_install() {
	if use apop; then
		dosbin popper/popauth
		fowners pop:root /usr/sbin/popauth
		fperms 4110 /usr/sbin/popauth
		doman man/popauth.8
	fi

	dosbin popper/popper || die
	doman man/popper.8 || die

	insinto /etc
	doins "${FILESDIR}/qpopper.conf" || die

	if use ssl; then
		sed -i -e 's:^# \(set tls-server-cert-file\).*:\1 = /etc/mail/certs/cert.pem:' \
			   -e 's:^# \(set tls-support\).*$:\1 = stls:'\
			"${D}/etc/qpopper.conf"
	fi

	if use xinetd; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/qpopper.xinetd" pop-3 || die
	else
		newinitd "${FILESDIR}/qpopper.init.d" qpopper || die
	fi

	dodoc README doc/{Release.Notes,Changes} || die

	docinto rfc
	dodoc doc/rfc*.txt || die
	dohtml doc/LMOS-FAQ.html || die

	insinto /usr/share/doc/${PF}
	doins GUIDE.pdf || die
}

pkg_postinst () {
	if use ssl; then
		install_cert /etc/mail/certs/cert
		chown root:mail /etc/mail/certs
		chmod 660 /etc/mail/certs
	fi
	if use apop; then
		elog "To authenticate the users with APOP "
		elog "you have to follow these steps:"
		elog ""
		elog "1) initialize the authentication database:"
		elog "   # popauth -init"
		elog "2) new users can be added by root:"
		elog "   # popauth -user <user>"
		elog "   or removed:"
		elog "   # popauth -delete <user>"
		elog "   Other users can add themeselves or change their"
		elog "   password with the command popauth"
		elog "3) scripts or other non-interactive processes can add or change"
		elog "   the passwords with the following command:"
		elog "   # popauth -user <user> <password>"
		elog ""
	fi
}
