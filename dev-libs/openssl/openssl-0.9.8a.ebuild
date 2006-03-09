# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/openssl/openssl-0.9.8a.ebuild,v 1.5 2006/03/09 23:49:09 vapier Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Toolkit for SSL v2/v3 and TLS v1"
HOMEPAGE="http://www.openssl.org/"
SRC_URI="mirror://openssl/source/${P}.tar.gz"

LICENSE="openssl"
SLOT="0"
KEYWORDS="-*"
IUSE="emacs test bindist zlib"

RDEPEND=""
DEPEND="${RDEPEND}
	sys-apps/diffutils
	>=dev-lang/perl-5
	test? ( sys-devel/bc )"
PDEPEND="app-misc/ca-certificates"

src_unpack() {
	unpack ${A}

	cd "${S}"

	epatch "${FILESDIR}"/${PN}-0.9.8-ppc64.patch
	epatch "${FILESDIR}"/${PN}-0.9.7e-gentoo.patch
	epatch "${FILESDIR}"/${PN}-0.9.8-hppa-fix-detection.patch
	epatch "${FILESDIR}"/${PN}-0.9.7-alpha-default-gcc.patch
	epatch "${FILESDIR}"/${PN}-0.9.8-parallel-build.patch
	epatch "${FILESDIR}"/${PN}-0.9.8-make-engines-dir.patch
	epatch "${FILESDIR}"/${PN}-0.9.8-toolchain.patch

	# allow openssl to be cross-compiled
	cp "${FILESDIR}"/gentoo.config-0.9.8 gentoo.config || die "cp cross-compile failed"
	chmod a+rx gentoo.config

	# Don't build manpages if we don't want them
	has noman FEATURES \
		&& sed -i '/^install:/s:install_docs::' Makefile.org \
		|| sed -i '/^MANDIR=/s:=.*:=/usr/share/man:' Makefile.org

	# Try to derice users
	[[ $(gcc-major-version) == "3" ]] \
		&& filter-flags -fprefetch-loop-arrays -freduce-all-givs -funroll-loops
	[[ $(tc-arch) == ppc* ]] && append-flags -fno-strict-aliasing
	append-flags -Wa,--noexecstack

	# using a library directory other than lib requires some magic
	sed -i \
		-e "s+\(\$(INSTALL_PREFIX)\$(INSTALLTOP)\)/lib+\1/$(get_libdir)+g" \
		-e "s+libdir=\$\${exec_prefix}/lib+libdir=\$\${exec_prefix}/$(get_libdir)+g" \
		Makefile.org engines/Makefile \
		|| die "sed failed"
	./config --test-sanity || die "I AM NOT SANE"
}

src_compile() {
	tc-export CC AR RANLIB

	# Clean out patent-or-otherwise-encumbered code
	# MDC-2: 4,908,861 13/03/2007
	# IDEA:  5,214,703 25/05/2010
	# RC5:   5,724,428 03/03/2015
	# EC:    ????????? ??/??/2015
	local confopts=""
	if use bindist ; then
		confopts="no-idea no-rc5 no-mdc2 no-ec"
	else
		confopts="enable-idea enable-rc5 enable-mdc2 enable-ec"
	fi
	use zlib && confopts="${confopts} zlib-dynamic"

	local sslout=$(./gentoo.config)
	einfo "Use configuration ${sslout:-(openssl knows best)}"
	local config="Configure"
	[[ -z ${sslout} ]] && config="config"
	./${config} \
		${sslout} \
		${confopts} \
		--prefix=/usr \
		--openssldir=/etc/ssl \
		shared threads \
		|| die "Configure failed"

	# Clean out hardcoded flags that openssl uses
	local CFLAG=$(grep ^CFLAG= Makefile | LC_ALL=C sed \
		-e 's:^CFLAG=::' \
		-e 's:-fomit-frame-pointer ::g' \
		-e 's:-O[0-9] ::g' \
		-e 's:-march=[-a-z0-9]* ::g' \
		-e 's:-mcpu=[-a-z0-9]* ::g' \
		-e 's:-m[a-z0-9]* ::g' \
	)
	sed -i -e "/^CFLAG/s:=.*:=${CFLAG} ${CFLAGS}:" Makefile || die

	# depend is needed to use $confopts
	# rehash is needed to prep the certs/ dir
	emake -j1 depend || die "depend failed"
	emake all rehash || die "make all failed"

	# force until we get all the gentoo.config kinks worked out
	src_test
}

src_test() {
	tc-is-cross-compiler && return 0

	# make sure sandbox doesnt die on *BSD
	add_predict /dev/crypto

	make test || die "make test failed"
}

src_install() {
	make INSTALL_PREFIX="${D}" install || die
	dodoc CHANGES* FAQ NEWS README
	dodoc doc/*.txt
	dohtml doc/*

	if use emacs ; then
		insinto /usr/share/emacs/site-lisp
		doins doc/c-indentation.el
	fi

	# create the certs directory
	dodir /etc/ssl/certs
	cp -RP certs/* "${D}"/etc/ssl/certs/ || die "failed to install certs"
	rm -r "${D}"/etc/ssl/certs/{demo,expired}

	# These man pages conflict with other packages so rename them
	cd "${D}"/usr/share/man
	for m in man1/passwd.1 man3/rand.3 man3/err.3 ; do
		d=${m%%/*} ; m=${m##*/}
		mv -f ${d}/{,ssl-}${m}
		ln -snf ssl-${m} ${d}/openssl-${m}
	done
}

pkg_preinst() {
	if [[ -e ${ROOT}/usr/$(get_libdir)/libcrypto.so.0.9.7 ]] ; then
		cp -pPR "${ROOT}"/usr/$(get_libdir)/lib{crypto,ssl}.so.0.9.7 "${IMAGE}"/usr/$(get_libdir)/
	fi
}

pkg_postinst() {
	if [[ -e ${ROOT}/usr/$(get_libdir)/libcrypto.so.0.9.7 ]] ; then
		ewarn "You must re-compile all packages that are linked against"
		ewarn "OpenSSL 0.9.7 by using revdep-rebuild from gentoolkit:"
		ewarn "# revdep-rebuild --library libssl.so.0.9.7"
		ewarn "# revdep-rebuild --library libcrypto.so.0.9.7"
		ewarn "After this, you can delete /usr/$(get_libdir)/libssl.so.0.9.7"
		ewarn "and /usr/$(get_libdir)/libcrypto.so.0.9.7"
	fi
}
