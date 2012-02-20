# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gsasl/gsasl-1.6.1.ebuild,v 1.9 2012/02/20 10:43:16 naota Exp $

EAPI="2"

inherit autotools eutils

DESCRIPTION="The GNU SASL client, server, and library"
HOMEPAGE="http://www.gnu.org/software/gsasl/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc gcrypt idn kerberos nls ntlm static-libs"

DEPEND="
	gcrypt? ( dev-libs/libgcrypt )
	idn? ( net-dns/libidn )
	kerberos? ( virtual/krb5 )
	nls? ( >=sys-devel/gettext-0.18.1 )
	ntlm? ( net-libs/libntlm )
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-gss-extra.patch"
	eautoreconf
}

src_configure() {
	econf \
		--enable-client \
		--enable-server \
		--disable-valgrind-tests \
		--disable-rpath \
		--without-libshishi \
		--without-libgss \
		--disable-kerberos_v5 \
		$(use_enable kerberos gssapi) \
		$(use_enable kerberos gs2) \
		$(use_with gcrypt libgcrypt) \
		$(use_enable nls) \
		$(use_with idn stringprep) \
		$(use_enable ntlm) \
		$(use_with ntlm libntlm) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	if ! use static-libs; then
		rm -f "${D}"/usr/lib*/lib*.la
	fi
	dodoc AUTHORS ChangeLog INSTALL NEWS README THANKS
	doman doc/gsasl.1 doc/man/*.3

	if use doc; then
		dodoc doc/*.{eps,ps,pdf}
		dohtml doc/*.html
		docinto examples
		dodoc examples/*.c
	fi
}
