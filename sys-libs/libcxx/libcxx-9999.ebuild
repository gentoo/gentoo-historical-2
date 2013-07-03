# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libcxx/libcxx-9999.ebuild,v 1.15 2013/07/03 21:17:16 aballier Exp $

EAPI=5

ESVN_REPO_URI="http://llvm.org/svn/llvm-project/libcxx/trunk"

[ "${PV%9999}" != "${PV}" ] && SCM="subversion" || SCM=""

inherit ${SCM} flag-o-matic toolchain-funcs multilib

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="http://libcxx.llvm.org/"
if [ "${PV%9999}" = "${PV}" ] ; then
	SRC_URI="mirror://gentoo/${P}.tar.xz"
else
	SRC_URI=""
fi

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
if [ "${PV%9999}" = "${PV}" ] ; then
	KEYWORDS="~amd64 ~x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
else
	KEYWORDS=""
fi
IUSE="elibc_glibc +libcxxrt static-libs test"

RDEPEND="libcxxrt? ( >=sys-libs/libcxxrt-0.0_p20130530[static-libs?] )
	!libcxxrt? ( sys-devel/gcc[cxx] )"
DEPEND="${RDEPEND}
	test? ( sys-devel/clang )
	app-arch/xz-utils"

src_prepare() {
	cp -f "${FILESDIR}/Makefile" lib/ || die
}

src_compile() {
	export LIBS="-lpthread -lrt -lc -lgcc_s"
	if use libcxxrt ; then
		append-cppflags -DLIBCXXRT "-I${EPREFIX}/usr/include/libcxxrt/"
		LIBS="-lcxxrt ${LIBS}"
	else
		# Very hackish, see $HOMEPAGE
		# If someone has a clever idea, please share it!
		local includes="$(echo | "$(tc-getCXX)" -Wp,-v -x c++ - -fsyntax-only 2>&1 | grep -C 2 '#include.*<...>' | tail -n 2 | sed -e 's/^ /-I/' | tr '\n' ' ')"
		append-cppflags -D__GLIBCXX__ ${includes}
		LIBS="-lsupc++ ${LIBS}"
	fi

	tc-export AR CC CXX

	append-ldflags "-Wl,-z,defs" # make sure we are not underlinked

	cd "${S}/lib" || die
	emake shared
	use static-libs && emake static
}

# Tests fail for now, if anybody is able to fix them, help is very welcome.
src_test() {
	cd "${S}/test"
	LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}" \
		CC="clang++" \
		HEADER_INCLUDE="-I${S}/include" \
		SOURCE_LIB="-L${S}/lib" \
		LIBS="-lm" \
		./testit || die
}

gen_static_ldscript() {
	if use libcxxrt ; then
		# Move it first.
		mv "${D}/${EPREFIX}/usr/$(get_libdir)/libc++.a"	"${D}/${EPREFIX}/usr/$(get_libdir)/libc++_static.a" || die

		# Generate libc++.a ldscript for inclusion of its dependencies so that
		# clang++ -stdlib=libc++ -static works out of the box.
		# Taken from toolchain-funcs.eclass:
		local output_format
		output_format=$($(tc-getCC) ${CFLAGS} ${LDFLAGS} -Wl,--verbose 2>&1 | sed -n 's/^OUTPUT_FORMAT("\([^"]*\)",.*/\1/p')
		[[ -n ${output_format} ]] && output_format="OUTPUT_FORMAT ( ${output_format} )"

		local deps="${EPREFIX}/usr/$(get_libdir)/libc++_static.a ${EPREFIX}/usr/$(get_libdir)/libcxxrt.a"
		# On Linux/glibc it does not link without libpthread or libdl. It is
		# fine on FreeBSD.
		use elibc_glibc && deps="${deps} ${EPREFIX}/usr/$(get_libdir)/libpthread.a ${EPREFIX}/usr/$(get_libdir)/libdl.a"

		cat > "${D}/${EPREFIX}/usr/$(get_libdir)/libc++.a" <<-END_LDSCRIPT
/* GNU ld script
   Include libc++.a dependencies for 'clang++ -stdlib=libc++ -static' to work
   out of the box.
 */
${output_format}
GROUP ( ${deps} )
END_LDSCRIPT
	fi
	# TODO: Generate a libc++.a ldscript when building against libsupc++
}

src_install() {
	cd "${S}/lib"
	if use static-libs ; then
		dolib.a libc++.a
		gen_static_ldscript
	fi
	dolib.so libc++.so*

	cd "${S}"
	insinto /usr/include/c++/v1
	doins -r include/*

	dodoc CREDITS.TXT
}

pkg_postinst() {
	elog "This package (${PN}) is mainly intended as a replacement for the C++"
	elog "standard library when using clang."
	elog "To use it, instead of libstdc++, use:"
	elog "    clang++ -stdlib=libc++"
	elog "to compile your C++ programs."
}
