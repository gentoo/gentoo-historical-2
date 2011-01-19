# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/parrot/parrot-3.0.0.ebuild,v 1.1 2011/01/19 12:59:31 patrick Exp $

EAPI=3

inherit eutils multilib

DESCRIPTION="Virtual machine designed to efficiently compile and execute bytecode for dynamic languages"
HOMEPAGE="http://www.parrot.org/"
#SRC_URI="ftp://ftp.parrot.org/pub/parrot/releases/supported/${PV}/${P}.tar.bz2"
SRC_URI="ftp://ftp.parrot.org/pub/parrot/releases/stable/${PV}/${P}.tar.bz2"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="opengl nls doc examples gdbm gmp ssl +unicode pcre"

RDEPEND="sys-libs/readline
	opengl? ( media-libs/freeglut )
	nls? ( sys-devel/gettext )
	unicode? ( >=dev-libs/icu-2.6 )
	gdbm? ( >=sys-libs/gdbm-1.8.3-r1 )
	gmp? ( >=dev-libs/gmp-4.1.4 )
	ssl? ( dev-libs/openssl )
	pcre? ( dev-libs/libpcre )"

DEPEND="dev-lang/perl[doc?]
	${RDEPEND}"

src_configure() {
	myconf="--disable-rpath"
	use unicode || myconf+=" --without-icu"
	use ssl     || myconf+=" --without-crypto"
	use gdbm    || myconf+=" --without-gdbm"
	use nls     || myconf+=" --without-gettext"
	use gmp     || myconf+=" --without-gmp"
	use opengl  || myconf+=" --without-opengl"
	use pcre    || myconf+=" --without-pcre"

	perl Configure.pl \
		--ccflags="${CFLAGS}" \
		--linkflags="${LDFLAGS}" \
		--prefix="${EROOT}"/usr \
		--libdir="${EROOT}"/usr/$(get_libdir) \
		--mandir="${EROOT}"/usr/share/man \
		--sysconfdir="${EROOT}"/etc \
		--sharedstatedir="${EROOT}"/var/lib/parrot \
		--pkgconfigdir=pkgconfig \
		$myconf || die
}

src_compile() {
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}"${S}"/blib/lib
	# occasionally dies in parallel make
	emake -j1 || die
	if use doc ; then
		emake -j1 html || die
	fi
}

src_test() {
	emake -j1 test || die
}

src_install() {
	emake -j1 install-dev DESTDIR="${ED}" DOC_DIR="${EROOT}/usr/share/doc/${PF}" || die
	dodoc CREDITS DEPRECATED.pod DONORS.pod NEWS PBC_COMPAT PLATFORMS RESPONSIBLE_PARTIES TODO || die
	if use examples; then
		insinto "${EROOT}/usr/share/doc/${PF}/examples"
		doins -r examples/* || die
	fi
	if use doc; then
		insinto "${EROOT}/usr/share/doc/${PF}/editor"
		doins -r editor || die
		cd docs/html
		dohtml -r developer.html DONORS.pod.html index.html ops.html parrotbug.html pdds.html \
			pmc.html tools.html docs src tools || die
	fi
}
