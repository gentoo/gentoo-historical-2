# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/erlang/erlang-11.2.2-r1.ebuild,v 1.2 2006/12/29 23:31:18 opfer Exp $

inherit elisp eutils flag-o-matic multilib versionator

# NOTE: When bumping you need to adjust the *_VER strings in
#  src_install() to honour newer versions in the package (they
#  are maintained separately upstream).
#  As High Performance Erlang (HiPE) messes around a lot with
#  assembler, it breaks hardened and some normal systems, so it has
#  been disabled.  Try with newer versions though.
#  If you need symlinks for binaries please tell maintainers or open up a bug
#  to let it be created.

# erlang uses a really weird versioning scheme which caused quite a few problems
# already. Thus we do a slight modification converting all letters to digits to
# make it more sane (see e.g. #26420)

# the next line selects the right source.
MY_PV="R$(get_major_version)B-$(get_version_component_range 3)"

# ATTN!! Take care when processing the C, etc version!
MY_P=otp_src_${MY_PV}

DESCRIPTION="Erlang programming language, runtime environment, and large collection of libraries"
HOMEPAGE="http://www.erlang.org/"
SRC_URI="http://www.erlang.org/download/${MY_P}.tar.gz
	doc? ( http://erlang.org/download/otp_doc_man_${MY_PV}.tar.gz
		http://erlang.org/download/otp_doc_html_${MY_PV}.tar.gz )"
# Not yet available for 11.2.1
#	http://developer.sipphone.com/ejabberd/erlang_epoll_patch/otp_src_${MY_PV}_epoll.patch"

LICENSE="EPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="doc emacs hipe java odbc ssl tk"

RDEPEND=">=dev-lang/perl-5.6.1
	ssl? ( >=dev-libs/openssl-0.9.7d )
	emacs? ( virtual/emacs )
	java? ( >=virtual/jdk-1.2 )
	odbc? ( dev-db/unixODBC )"
DEPEND="${RDEPEND}
	tk? ( dev-lang/tk )"

S="${WORKDIR}/${MY_P}"

SITEFILE=50erlang-gentoo.el

src_unpack() {
	## fix compilation on hardened systems, see bug #154338
	filter-flags "-fstack-protector"
	filter-flags "-fstack-protector-all"

	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-10.2.6-export-TARGET.patch"
	epatch "${FILESDIR}/10.2.6-manpage-emacs-gentoo.patch"
	use odbc || sed -i 's: odbc : :' lib/Makefile
#	epatch "${DISTDIR}"/otp_src_${MY_PV}_epoll.patch

	if use hipe; then
		# Fix for bug #151612
		sed -i "s/__GLIBC_MINOR__\ ==\ 3/__GLIBC_MINOR__\ \>=\ 3/g" \
			${S}/erts/emulator/hipe/hipe_x86_signal.c
		ewarn
		ewarn "You enabled High performance Erlang. Be aware that this extension"
		ewarn "can break the compilation in many ways, especially on hardened systems."
		ewarn "Don't cry, don't file bugs, just disable it!"
		ewarn
	fi
}

src_compile() {
	use java || export JAVAC=false
	# disable High Performance Erlang (HiPE) to avoid a lot of
	# problems on hardened, bug #154338
	# Test every new version on hardened!
	econf \
		--enable-threads \
		$(use_enable hipe) \
		$(use_with ssl) \
		|| die "econf failed"
	make || die "emake failed"

	if use emacs ; then
		pushd lib/tools/emacs
		elisp-compile *.el
		popd
	fi
}

extract_version() {
	sed -n -e "/^$2 = \(.*\)$/s::\1:p" "${S}/$1/vsn.mk"
}

src_install() {
	local ERL_LIBDIR=/usr/$(get_libdir)/erlang
	local ERL_INTERFACE_VER=$(extract_version lib/erl_interface EI_VSN)
	local ERL_ERTS_VER=$(extract_version erts VSN)

	make INSTALL_PREFIX="${D}" install || die
	dodoc AUTHORS EPLICENCE README

	dosym ${ERL_LIBDIR}/bin/erl /usr/bin/erl
	dosym ${ERL_LIBDIR}/bin/erlc /usr/bin/erlc
	dosym ${ERL_LIBDIR}/bin/ecc /usr/bin/ecc
	dosym ${ERL_LIBDIR}/bin/elink /usr/bin/elink
	dosym ${ERL_LIBDIR}/bin/ear /usr/bin/ear
	dosym ${ERL_LIBDIR}/bin/escript /usr/bin/escript
	dosym \
		${ERL_LIBDIR}/lib/erl_interface-${ERL_INTERFACE_VER}/bin/erl_call \
		/usr/bin/erl_call
	dosym ${ERL_LIBDIR}/erts-${ERL_ERTS_VER}/bin/beam /usr/bin/beam

	## Remove ${D} from the following files
	dosed ${ERL_LIBDIR}/bin/erl
	dosed ${ERL_LIBDIR}/bin/start
	cd ${ERL_LIBDIR}/erts-${ERL_ERTS_VER}
	grep -rle "${D}" "${D}"/${ERL_LIBDIR}/erts-${ERL_ERTS_VER} | xargs sed -i -e "s:${D}::g"

	## Clean up the no longer needed files
	rm "${D}"/${ERL_LIBDIR}/Install

	if use doc ; then
		for i in "${WORKDIR}"/man/man* ; do
			dodir /usr/share/${i##${WORKDIR}}erl
		done
		for file in "${WORKDIR}"/man/man*/*.[1-9]; do
			# Avoid namespace collisions
			local newfile=${file}erl
			cp ${file} ${newfile}
			# Man page processing tools expect a capitalized "SEE ALSO" section
			# header
			sed -i -e 's,\.SH See Also,\.SH SEE ALSO,g' ${newfile}
			# doman sucks so we can't use it
			cp ${newfile} "${D}"/usr/share/man/man${newfile##*.}/
		done
		dohtml -A README,erl,hrl,c,h,kwc,info -r \
			"${WORKDIR}"/doc "${WORKDIR}"/lib "${WORKDIR}"/erts-*
	fi

	if use emacs ; then
		pushd "${S}"
		elisp-install erlang lib/tools/emacs/*.{el,elc}
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
		popd
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
	einfo
	einfo "If you need a symlink to one of erlang's binaries,"
	einfo "please open a bug and tell the maintainers."
	einfo
}
