# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xmlsec/xmlsec-1.2.15.ebuild,v 1.1 2010/04/29 18:57:40 arfrever Exp $

EAPI="3"

DESCRIPTION="Command line tool for signing, verifying, encrypting and decrypting XML"
HOMEPAGE="http://www.aleksey.com/xmlsec"
SRC_URI="http://www.aleksey.com/xmlsec/download/${PN}1-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="gnutls mozilla ssl"

RDEPEND=">=dev-libs/libxml2-2.7.4
	>=dev-libs/libxslt-1.0.20
	gnutls? ( >=net-libs/gnutls-0.8.1 )
	mozilla? ( >=dev-libs/nspr-4.0
		>=dev-libs/nss-3.2 )
	ssl? ( >=dev-libs/openssl-0.9.7 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${PN}1-${PV}"

#src_prepare() {
#	eautoreconf
#	append-cppflags '-DLTDL_OBJDIR=\".libs\"' '-DLTDL_SHLIB_EXT=\".so\"'
#}

src_configure() {
	local myconf
	use gnutls || myconf="--without-gnutls"
	econf \
		--enable-pkgconfig \
		--enable-xkms \
		$(use_enable ssl aes) \
		$(use_with ssl openssl /usr) \
		--with-html-dir=/usr/share/doc/${PF} \
		${myconf}
}

src_test() {
	TMPFOLDER="${T}" emake check || die "emake check failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS README NEWS || die "dodoc failed"
}
