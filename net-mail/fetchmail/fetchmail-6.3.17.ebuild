# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/fetchmail/fetchmail-6.3.17.ebuild,v 1.1 2010/05/06 13:29:25 tove Exp $

EAPI=2

PYTHON_DEPEND="2"
PYTHON_USE_WITH_OPT="tk"
PYTHON_USE_WITH="tk"

inherit multilib python eutils

DESCRIPTION="the legendary remote-mail retrieval and forwarding utility"
HOMEPAGE="http://fetchmail.berlios.de"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="ssl nls kerberos hesiod tk"

RDEPEND="hesiod? ( net-dns/hesiod )
	ssl? ( >=dev-libs/openssl-0.9.6 )
	kerberos? ( virtual/krb5 >=dev-libs/openssl-0.9.6 )
	nls? ( virtual/libintl )
	elibc_FreeBSD? ( sys-libs/com_err )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
	use tk && python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	# dont compile during src_install
	: > "${S}"/py-compile
}

src_configure() {
	if use tk ; then
		export PYTHON=$(PYTHON -a )
	else
		export PYTHON=:
	fi
	econf \
		--disable-dependency-tracking \
		--enable-RPA \
		--enable-NTLM \
		--enable-SDPS \
		$(use_enable nls) \
		$(use_with ssl) \
		$(use kerberos && echo "--with-ssl" ) \
		$(use_with kerberos gssapi) \
		$(use_with kerberos kerberos5) \
		$(use_with hesiod) \
		${myconf} || die "Configuration failed."
}

src_install() {
	# dir for pidfile
	dodir /var/run/${PN} || die "dodir failed"
	keepdir /var/run/${PN}
	fowners ${PN}:${PN} /var/run/${PN} || die "fowners failed"

	# fetchmail's homedir (holds fetchmail's .fetchids)
	dodir /var/lib/${PN} || die "dodir failed"
	keepdir /var/lib/${PN}
	fowners ${PN}:${PN} /var/lib/${PN} || die "fowners failed"
	fperms 700 /var/lib/${PN} || die "fperms failed"

	emake DESTDIR="${D}" install || die

	dohtml *.html

	dodoc FAQ FEATURES NEWS NOTES README README.NTLM README.SSL* TODO || die

	newinitd "${FILESDIR}"/fetchmail.new fetchmail || die
	newconfd "${FILESDIR}"/conf.d-fetchmail fetchmail || die

	docinto contrib
	local f
	for f in contrib/* ; do
		[ -f "${f}" ] && dodoc "${f}"
	done
}

pkg_postinst() {
	use tk && python_mod_optimize "$(python_get_sitedir)/fetchmailconf.py"

	ewarn "From the NEWS:"
	ewarn "Fetchmail now supports a bad-header command line or rcfile option that takes"
	ewarn "exactly one argument, accept or reject (default).  This specifies how messages"
	ewarn "with bad headers retrieved from the current server are to be treated."
	ewarn ""
	ewarn "Gentoo's previous fetchmail versions (<6.3.16) accepted messages with bad"
	ewarn "headers. So if you upgrade you must update your configuration files"
	ewarn "to imitate the old behavior."
	echo

	elog "Please see /etc/conf.d/fetchmail if you want to adjust"
	elog "the polling delay used by the fetchmail init script."
}

pkg_postrm() {
	use tk && python_mod_cleanup "$(python_get_sitedir)/fetchmailconf.py"
}
