# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ocaml/ocaml-3.09.3-r1.ebuild,v 1.2 2007/04/22 20:00:56 phreak Exp $

inherit flag-o-matic eutils multilib pax-utils versionator toolchain-funcs

DESCRIPTION="fast modern type-inferring functional programming language descended from the ML (Meta Language) family"
HOMEPAGE="http://www.ocaml.org/"
SRC_URI="http://caml.inria.fr/distrib/ocaml-$( get_version_component_range 1-2 )/${P}.tar.bz2"

LICENSE="QPL-1.0 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="tk latex"

DEPEND="virtual/libc
	tk? ( >=dev-lang/tk-3.3.3 )"

# ocaml deletes the *.opt files when running bootstrap
RESTRICT="test"

QA_EXECSTACK="/usr/lib/ocaml/compiler-*"

pkg_setup() {
	# dev-lang/ocaml fails with -fPIC errors due to a "relocation R_X86_64_32S" on AMD64/hardened
	if use amd64 && gcc-specs-pie ; then
		echo
		eerror "${CATEGORY}/${PF} is currently broken on this platform with specfiles injecting -PIE."
		eerror "Please switch to your \"${CHOST}-$(gcc-fullversion)-hardenednopie\" specfile via gcc-config!"
		die "Current specfile (${CHOST}-$(gcc-fullversion)) not supported by ${PF}!"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix the EXEC_STACK in ocaml compiled binaries (#153382)
	epatch "${FILESDIR}"/${P}-exec-stack-fixes.patch

	# Quick and somewhat dirty fix for bug #110541
	epatch "${FILESDIR}"/${P}-execheap.patch

	# The configure script doesn't inherit previous defined variables, 
	# overwriting previous declarations of bytecccompopts, bytecclinkopts,
	# nativecccompopts and nativecclinkopts. Reported upstream as issue 0004267.
	epatch "${FILESDIR}"/${P}-configure.patch

	# The sed in the Makefile doesn't replace all occurences of @compiler@
	# in driver/ocamlcomp.sh.in. Reported upstream as issue 0004268.
	epatch "${FILESDIR}"/${P}-Makefile.patch

	# Change the configure script to add the CFLAGS to bytecccompopts, LDFLAGS
	# to bytecclinkopts.
	sed -i -e "s,bytecccompopts=\"\",bytecccompopts=\"\${CFLAGS}\"," \
		-e "s,bytecclinkopts=\"\",bytecclinkopts=\"\${LDFLAGS}\"," \
		"${S}"/configure
}

src_compile() {
	local myconf="--host ${CHOST}"

	# dev-lang/ocaml tends to break/give unexpected results with "unsafe" CFLAGS.
	strip-flags
	replace-flags "-O?" -O2

	use tk || myconf="-no-tk"

	# ocaml uses a home-brewn configure script, preventing it to use econf.
	./configure -prefix /usr \
		--bindir /usr/bin \
		--libdir /usr/$(get_libdir)/ocaml \
		--mandir /usr/share/man \
		--with-pthread ${myconf} || die "configure failed!"

	make world || die "make world failed!"

	# Native code generation is unsupported on some archs
	if ! use ppc64 ; then
		make opt || die "make opt failed!"
		make opt.opt || die "make opt.opt failed!"
	fi
}

#src_test() {
#	make bootstrap
#}

src_install() {
	make BINDIR="${D}"/usr/bin \
		LIBDIR="${D}"/usr/$(get_libdir)/ocaml \
		MANDIR="${D}"/usr/share/man \
		install || die "make install failed!"

	# Install the compiler libs
	dodir /usr/$(get_libdir)/ocaml/compiler-libs
	insinto /usr/$(get_libdir)/ocaml/compiler-libs
	doins {utils,typing,parsing}/*.{mli,cmi,cmo,cmx,o}

	# Symlink the headers to the right place
	dodir /usr/include
	dosym /usr/$(get_libdir)/ocaml/caml /usr/include/

	# Remove ${D} from ld.conf, as the buildsystem isn't $(DESTDIR) aware
	dosed "s:${D}::g" /usr/$(get_libdir)/ocaml/ld.conf

	dodoc Changes INSTALL LICENSE README Upgrading

	# Turn MPROTECT off for some of the ocaml binaries, since they are trying to
	# rewrite the segment (which will obviously fail on systems having
	# PAX_MPROTECT enabled).
	pax-mark -m "${D}"/usr/bin/ocamldoc.opt "${D}"/usr/bin/ocamldep.opt \
		"${D}"/usr/bin/ocamllex.opt "${D}"/usr/bin/camlp4r.opt \
		"${D}"/usr/bin/camlp4o.opt

	# Create and envd entry for latex input files (this definitely belongs into
	# CONTENT and not in pkg_postinst.
	if use latex ; then
		echo "TEXINPUTS=/usr/$(get_libdir)/ocaml/ocamldoc:" > "${T}"/99ocamldoc
		doenvd "${T}"/99ocamldoc
	fi
}

pkg_postinst() {
	if use amd64 && gcc-specs-ssp ; then
		ewarn
		ewarn "Make sure, you switch back to the default specfile ${CHOST}-$(gcc-fullversion) via gcc-config!"
		ewarn
	fi

	echo
	elog "OCaml is not binary compatible from version to version, so you (may)"
	elog "need to rebuild all packages depending on it, that are actually"
	elog "installed on your system. To do so, you can run:"
	elog "sh ${FILESDIR}/ocaml-rebuild.sh [-h | emerge options]"
	elog "Which will call emerge on all old packages with the given options"
	echo
}
