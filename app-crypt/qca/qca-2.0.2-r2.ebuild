# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca/qca-2.0.2-r2.ebuild,v 1.12 2010/01/13 18:44:41 abcd Exp $

EAPI="2"

inherit eutils multilib qt4

DESCRIPTION="Qt Cryptographic Architecture (QCA)"
HOMEPAGE="http://delta.affinix.com/qca/"
SRC_URI="http://delta.affinix.com/download/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="aqua debug doc examples"
RESTRICT="test"

DEPEND="x11-libs/qt-core:4[debug?]"
RDEPEND="${DEPEND}
	!<app-crypt/qca-1.0-r3:0
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-pcfilespath.patch

	use aqua && sed -i \
		-e "s|QMAKE_LFLAGS_SONAME =.*|QMAKE_LFLAGS_SONAME = -Wl,-install_name,|g" \
		src/src.pro
}

src_configure() {
	use prefix || EPREFIX=

	_libdir=$(get_libdir)

	# Ensure proper rpath
	export EXTRA_QMAKE_RPATH="${EPREFIX}/usr/${_libdir}/qca2"

	./configure \
		--prefix="${EPREFIX}"/usr \
		--qtdir="${EPREFIX}"/usr \
		--includedir="${EPREFIX}"/usr/include/qca2 \
		--libdir="${EPREFIX}"/usr/${_libdir}/qca2 \
		--certstore-path="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt \
		--no-separate-debug-info \
		--disable-tests \
		--$(use debug && echo debug || echo release) \
		--no-framework \
		|| die "configure failed"

	eqmake4
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc README TODO || die "dodoc failed"

	cat <<-EOF > "${WORKDIR}"/44qca2
	LDPATH="${EPREFIX}/usr/${_libdir}/qca2"
	EOF
	doenvd "${WORKDIR}"/44qca2 || die

	if use doc; then
		dohtml "${S}"/apidocs/html/* || die "Failed to install documentation"
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/
		doins -r "${S}"/examples || die "Failed to install examples"
	fi

	# add the proper rpath for packages that do CONFIG += crypto
	echo "QMAKE_RPATHDIR += \"${EPREFIX}/usr/${_libdir}/qca2\"" >> \
		"${D%/}${EPREFIX}/usr/share/qt4/mkspecs/features/crypto.prf" \
		|| die "failed to add rpath to crypto.prf"
}
