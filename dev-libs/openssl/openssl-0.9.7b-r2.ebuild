# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/openssl/openssl-0.9.7b-r2.ebuild,v 1.2 2003/09/17 12:14:44 aliz Exp $

inherit eutils flag-o-matic gcc

if [ "$( gcc-fullversion )" == "3.3" ]; then
	filter-flags "-fprefetch-loop-arrays"
fi

OLD_096_P="${PN}-0.9.6j"

S=${WORKDIR}
DESCRIPTION="Toolkit for SSL v2/v3 and TLS v1"
SRC_URI="mirror://openssl/source/${P}.tar.gz
	mirror://openssl/source/${OLD_096_P}.tar.gz"
HOMEPAGE="http://www.openssl.org/"

RDEPEND="virtual/glibc"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	>=sys-apps/sed-4"
LICENSE="as-is"
SLOT="0"

KEYWORDS="~x86 ~ppc ~alpha ~sparc ~mips ~hppa ~arm"

src_unpack() {
	unpack ${A}

	# openssl-0.9.7
	cd ${WORKDIR}/${P}

	epatch ${FILESDIR}/${P}-gentoo.diff

	if [ "${ARCH}" = "hppa" ]; then
	sed -i -e \
	's!^"linux-parisc"\(.*\)::BN\(.*\)::!"linux-parisc"\1:-ldl:BN\2::::::::::dlfcn:linux-shared:-fPIC::.so.\\$(SHLIB_MAJOR).\\$(SHLIB_MINOR)!' \
		Configure
	fi
	if [ "${ARCH}" = "alpha" -a "${CC}" != "ccc" ]; then
	# ccc compiled openssl will break things linked against
	# a gcc compiled openssl, the configure will automatically detect 
	# ccc and use it, so stop that if user hasnt asked for it.
		sed -i -e \
			's!CC=ccc!CC=gcc!' config
	fi

	sed -i -e "s/-O3/$CFLAGS/" -e "s/-m486//" Configure

	# openssl-0.9.6
	test -f ${ROOT}/usr/lib/libssl.so.0.9.6 && {
		cd ${WORKDIR}/${OLD_096_P}

	        epatch ${FILESDIR}/${OLD_096_P}-gentoo.diff

		case ${ARCH} in
		mips)
			epatch ${FILESDIR}/openssl-0.9.6-mips.diff
		;;
		arm)
			# patch linker to add -ldl or things linking aginst libcrypto fail
			sed -i -e \
				's!^"linux-elf-arm"\(.*\)::BN\(.*\)!"linux-elf-arm"\1:-ldl:BN\2!' \
				Configure
		;;
		hppa)
			sed -i -e \
				's!^"linux-parisc"\(.*\)::BN\(.*\)::!"linux-parisc"\1:-ldl:BN\2::::::::::dlfcn:linux-shared:-fPIC::.so.\\$(SHLIB_MAJOR).\\$(SHLIB_MINOR)!' \
				Configure
		esac

		sed -i -e "s/-O3/$CFLAGS/" -e "s/-m486//" Configure
	}
}

src_compile() {
	# openssl-0.9.7
	cd ${WORKDIR}/${P}
	./config --prefix=/usr --openssldir=/etc/ssl shared threads || die
	einfo "Compiling ${P}"
	make all || die

	# openssl-0.9.6
	test -f ${ROOT}/usr/lib/libssl.so.0.9.6 && {
		cd ${WORKDIR}/${OLD_096_P}

		if [ "$PROFILE_ARCH" = "sparc" -a "`uname -m`" = "sparc64" ]; then
			SSH_TARGET="linux-sparcv8"
		elif [ "`uname -m`" = "parisc64" ]; then
			SSH_TARGET="linux-parisc"
		fi

		case ${CHOST} in
		alphaev56*|alphaev6*)
			SSH_TARGET="linux-alpha+bwx-${CC:-gcc}"
		;;
		alpha*)
			SSH_TARGET="linux-alpha-${CC:-gcc}" ;;
		esac

		if [ ${SSH_TARGET} ]; then
			einfo "Forcing ${SSH_TARGET} compile"
			./Configure ${SSH_TARGET} --prefix=/usr \
				--openssldir=/etc/ssl shared threads || die
		else
			./config --prefix=/usr --openssldir=/etc/ssl shared threads || die
		fi

		einfo "Compiling ${OLD_096_P}"
		make all || die
	}
}

src_install() {
	# openssl-0.9.7
	cd ${WORKDIR}/${P}
	make INSTALL_PREFIX=${D} MANDIR=/usr/share/man install || die
	dodoc CHANGES* FAQ LICENSE NEWS README
	dodoc doc/*.txt
	dohtml doc/*
	insinto /usr/share/emacs/site-lisp
	doins doc/c-indentation.el

	# create the certs directory.  Previous openssl builds
	# would need to create /usr/lib/ssl/certs but this looks
	# to be the more FHS compliant setup... -raker
	insinto /etc/ssl/certs
	doins certs/*.pem
	OPENSSL=${D}/usr/bin/openssl /usr/bin/perl tools/c_rehash ${D}/etc/ssl/certs

	# The man pages rand.3 and passwd.1 conflict with other packages
	# Rename them to ssl-* and also make a symlink from openssl-* to ssl-*
	cd ${D}/usr/share/man/man1
	mv passwd.1 ssl-passwd.1
	ln -sf ssl-passwd.1 openssl-passwd.1
	cd ${D}/usr/share/man/man3
	mv rand.3 ssl-rand.3
	ln -sf ssl-rand.3 openssl-rand.3

	# openssl-0.9.6
	test -f ${ROOT}/usr/lib/libssl.so.0.9.6 && {
		dolib.so ${WORKDIR}/${OLD_096_P}/libcrypto.so.0.9.6
		dolib.so ${WORKDIR}/${OLD_096_P}/libssl.so.0.9.6
	}
}

pkg_postinst() {
	test -f ${ROOT}/usr/lib/libssl.so.0.9.6 && {
		einfo "You can now re-compile all packages that are linked against"
		einfo "OpenSSL 0.9.6 by using revdep-rebuild from gentoolkit:"
		einfo "# revdep-rebuild --soname libssl.so.0.9.6"
		einfo "# revdep-rebuild --soname libcrypto.so.0.9.6"
		einfo "After this, you can delete /usr/lib/libssl.so.0.9.6 and /usr/lib/libcrypto.so.0.9.6"
	}
}
