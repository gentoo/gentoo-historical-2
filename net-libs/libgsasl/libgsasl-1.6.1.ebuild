# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libgsasl/libgsasl-1.6.1.ebuild,v 1.11 2011/11/27 22:49:28 jer Exp $

EAPI="3"

inherit autotools eutils

DESCRIPTION="The GNU SASL library"
HOMEPAGE="http://www.gnu.org/software/gsasl/"
SRC_URI="mirror://gnu/${PN/lib}/${P}.tar.gz"
LICENSE="GPL-3 LGPL-3"
SLOT="0"
# TODO: check http://www.gnu.org/software/gsasl/#dependencies for more
# 	optional external libraries.
#   * ntlm - libntlm ( http://josefsson.org/libntlm/ )
KEYWORDS="alpha amd64 ~arm ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="idn gcrypt kerberos nls static-libs"
DEPEND="
	gcrypt? ( dev-libs/libgcrypt )
	idn? ( net-dns/libidn )
	kerberos? ( virtual/krb5 )
	nls? ( >=sys-devel/gettext-0.18.1 )
"
RDEPEND="${DEPEND}
	!net-misc/gsasl"

src_prepare() {
	epatch "${FILESDIR}/${PN}-gss-extra.patch"
	eautoreconf
}

src_configure() {
	econf \
		$(use_with gcrypt libgcrypt) \
		$(use_with idn stringprep) \
		$(use_enable kerberos gssapi) \
		$(use_enable kerberos kerberos_v5) \
		$(use_enable nls) \
		$(use_enable static-libs static) \
	|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed"
	if ! use static-libs; then
		rm -f "${D}"/usr/lib*/lib*.la
	fi
	dodoc AUTHORS ChangeLog NEWS README THANKS
}
