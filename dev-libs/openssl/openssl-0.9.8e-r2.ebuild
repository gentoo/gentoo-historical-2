# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/openssl/openssl-0.9.8e-r2.ebuild,v 1.7 2007/08/28 20:23:38 angelos Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Toolkit for SSL v2/v3 and TLS v1"
HOMEPAGE="http://www.openssl.org/"
SRC_URI="mirror://openssl/source/${P}.tar.gz"

LICENSE="openssl"
SLOT="0"
KEYWORDS="-* alpha amd64 arm hppa ia64 m68k ~mips ppc ~ppc64 s390 sh sparc x86"
IUSE="bindist emacs sse2 test zlib"

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
	epatch "${FILESDIR}"/${PN}-0.9.8b-parallel-build.patch
	epatch "${FILESDIR}"/${PN}-0.9.8-make-engines-dir.patch
	epatch "${FILESDIR}"/${PN}-0.9.8-toolchain.patch
	epatch "${FILESDIR}"/${PN}-0.9.8b-doc-updates.patch
	epatch "${FILESDIR}"/${PN}-0.9.8-makedepend.patch #149583
	epatch "${FILESDIR}"/${PN}-0.9.8-evp-key-len.patch #168750
	epatch "${FILESDIR}"/${PN}-0.9.8e-CVE-2007-3108.patch #188799
	[[ $(gcc-version) == "4.2" ]] && epatch "${FILESDIR}"/${PN}-0.9.8-gcc42.patch #158324

	# allow openssl to be cross-compiled
	cp "${FILESDIR}"/gentoo.config-0.9.8 gentoo.config || die "cp cross-compile failed"
	chmod a+rx gentoo.config

	# Don't build manpages if we don't want them
	has noman FEATURES \
		&& sed -i '/^install:/s:install_docs::' Makefile.org \
		|| sed -i '/^MANDIR=/s:=.*:=/usr/share/man:' Makefile.org

	# Try to derice users and work around broken ass toolchains
	if [[ $(gcc-major-version) == "3" ]] ; then
		filter-flags -fprefetch-loop-arrays -freduce-all-givs -funroll-loops
		[[ $(tc-arch) == "ppc64" ]] && replace-flags -O? -O
	fi
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
	# IDEA:  5,214,703 25/05/2010
	# RC5:   5,724,428 03/03/2015
	# EC:    ????????? ??/??/2015
	local confopts=""
	if use bindist ; then
		confopts="no-idea no-rc5 no-ec"
	else
		confopts="enable-idea enable-rc5 enable-mdc2 enable-ec"
	fi
	use zlib && confopts="${confopts} zlib-dynamic"
	use sse2 || confopts="${confopts} no-sse2"

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
	sed -i \
		-e "/^CFLAG/s:=.*:=${CFLAG} ${CFLAGS}:" \
		-e "/^SHARED_LDFLAGS=/s:$: ${LDFLAGS}:" \
		Makefile || die

	# depend is needed to use $confopts
	# rehash is needed to prep the certs/ dir
	emake -j1 depend || die "depend failed"
	emake all rehash || die "make all failed"

	# force until we get all the gentoo.config kinks worked out
	if has test ${FEATURES} && ! tc-is-cross-compiler ; then
		src_test
	fi
}

src_test() {
	# make sure sandbox doesnt die on *BSD
	addpredict /dev/crypto

	make test || die "make test failed"
}

src_install() {
	emake -j1 INSTALL_PREFIX="${D}" install || die
	dodoc CHANGES* FAQ NEWS README doc/*.txt
	dohtml doc/*

	if use emacs ; then
		insinto /usr/share/emacs/site-lisp
		doins doc/c-indentation.el
	fi

	# create the certs directory
	dodir /etc/ssl/certs
	cp -RP certs/* "${D}"/etc/ssl/certs/ || die "failed to install certs"
	rm -r "${D}"/etc/ssl/certs/{demo,expired}

	# Namespace openssl programs to prevent conflicts with other man pages
	cd "${D}"/usr/share/man
	local m d s
	for m in $(find . -type f | xargs grep -L '#include') ; do
		d=${m%/*} ; d=${d#./} ; m=${m##*/}
		[[ ${m} == openssl.1* ]] && continue
		mv ${d}/{,ssl-}${m}
		ln -s ssl-${m} ${d}/openssl-${m}
		# locate any symlinks that point to this man page
		for s in $(find ${d} -lname ${m}) ; do
			s=${s##*/}
			rm -f ${d}/${s}
			ln -s ssl-${m} ${d}/ssl-${s}
			ln -s ssl-${s} ${d}/openssl-${s}
		done
	done

	diropts -m0700
	keepdir /etc/ssl/private
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/lib{crypto,ssl}.so.0.9.{6,7}
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/lib{crypto,ssl}.so.0.9.{6,7}

	if [[ ${CHOST} == i686* ]] ; then
		ewarn "Due to the way openssl is architected, you cannot"
		ewarn "switch between optimized versions without breaking"
		ewarn "ABI.  The default i686 0.9.8 ABI was an unoptimized"
		ewarn "version with horrible performance.  This version uses"
		ewarn "the optimized ABI.  If you experience segfaults when"
		ewarn "using ssl apps (like openssh), just re-emerge the"
		ewarn "offending package."
	fi
}
