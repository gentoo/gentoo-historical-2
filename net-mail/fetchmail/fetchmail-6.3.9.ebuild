# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/fetchmail/fetchmail-6.3.9.ebuild,v 1.6 2009/01/10 10:11:52 maekke Exp $

inherit multilib python eutils

DESCRIPTION="the legendary remote-mail retrieval and forwarding utility"
HOMEPAGE="http://fetchmail.berlios.de"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="ssl nls ipv6 kerberos krb4 hesiod"

RDEPEND="hesiod? ( net-dns/hesiod )
	ssl? ( >=dev-libs/openssl-0.9.6 )
	kerberos? ( app-crypt/mit-krb5 )
	nls? ( virtual/libintl )
	elibc_FreeBSD? ( sys-libs/com_err )
	virtual/python"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# this patch fixes bug #34788 (ticho@gentoo.org 2004-09-03)
	epatch "${FILESDIR}"/${PN}-6.2.5-broken-headers.patch

	# dont compile during src_install
	: > "${S}"/py-compile
}

src_compile() {
#	PYTHON=: \
		econf \
		--disable-dependency-tracking \
		--enable-RPA \
		--enable-NTLM \
		--enable-SDPS \
		$(use_enable nls) \
		$(use_enable ipv6 inet6) \
		$(use_with kerberos gssapi) \
		$(use_with kerberos kerberos5) \
		$(use_with krb4 kerberos) \
		$(use_with ssl) \
		$(use_with hesiod) \
		${myconf} || die "Configuration failed."
	# wont compile reliably on smp (mkennedy@gentoo.org 2003-11-12)
	emake || die "Compilation failed."
}

src_install() {
	emake DESTDIR="${D}" install || die
	python_need_rebuild

	dohtml *.html

	dodoc FAQ FEATURES NEWS NOTES README README.NTLM README.SSL TODO || die

	newinitd "${FILESDIR}"/fetchmail fetchmail || die
	newconfd "${FILESDIR}"/conf.d-fetchmail fetchmail || die

	docinto contrib
	local f
	for f in contrib/* ; do
		[ -f "${f}" ] && dodoc "${f}"
	done
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages

	if ! python -c "import Tkinter" >/dev/null 2>&1
	then
		elog
		elog "You will not be able to use fetchmailconf(1), because you"
		elog "don't seem to have Python with tkinter support."
		elog
		elog "If you want to be able to use fetchmailconf(1), do the following:"
		elog "  1.  Add 'tk' to the USE variable in /etc/make.conf."
		elog "  2.  (Re-)merge Python."
		elog
	fi

	elog "Please see /etc/conf.d/fetchmail if you want to adjust"
	elog "the polling delay used by the fetchmail init script."
}

pkg_postrm() {
	python_version
	python_mod_cleanup /usr/$(get_libdir)/python${PYVER}/site-packages
}
