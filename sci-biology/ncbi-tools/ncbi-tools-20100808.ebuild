# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/ncbi-tools/ncbi-tools-20100808.ebuild,v 1.3 2010/11/15 21:03:06 jlec Exp $

EAPI="3"

inherit flag-o-matic toolchain-funcs eutils

DESCRIPTION="Development toolkit and applications for computational biology, including NCBI BLAST"
LICENSE="public-domain"
HOMEPAGE="http://www.ncbi.nlm.nih.gov/"
SRC_URI="ftp://ftp.ncbi.nlm.nih.gov/toolbox/ncbi_tools/old/${PV}/ncbi.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

# IUSE=mpi deprecated, use sci-biology/mpiblast separately
IUSE="doc X"

RDEPEND="app-shells/tcsh
	dev-lang/perl
	media-libs/libpng
	X? ( >=x11-libs/openmotif-2.3:0 )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/ncbi"

EXTRA_VIB="asn2all asn2asn"

pkg_setup() {
	echo
	ewarn 'Please note that the NCBI toolkit (and especially the X'
	ewarn 'applications) are known to have compilation and run-time'
	ewarn 'problems when compiled with agressive compilation flags. The'
	ewarn '"-O3" flag is filtered by the ebuild on the x86 architecture if'
	ewarn 'X support is enabled.'
	echo
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-extra_vib.patch

	if use ppc || use ppc64; then
		epatch "${FILESDIR}"/${PN}-lop.patch
	fi

	if ! use X; then
		cd "${S}"/make
		sed -e "s:\#set HAVE_OGL=0:set HAVE_OGL=0:" \
			-e "s:\#set HAVE_MOTIF=0:set HAVE_MOTIF=0:" \
			-i makedis.csh || die
	else
		if use x86; then
			# X applications segfault on startup on x86 with -O3.
			replace-flags '-O3' '-O2'
		fi
	fi

	# Apply user C flags...
	cd "${S}"/platform
	# ... on x86...
	sed -e "s/NCBI_CFLAGS1 = -c/NCBI_CFLAGS1 = -c ${CFLAGS}/" \
		-e "s/NCBI_LDFLAGS1 = -O3 -mcpu=pentium4/NCBI_LDFLAGS1 = ${CFLAGS} ${LDFLAGS}/" \
		-e "s/NCBI_OPTFLAG = -O3 -mcpu=pentium4/NCBI_OPTFLAG = ${CFLAGS}/" \
		-i linux-x86.ncbi.mk || die
	# ... on alpha...
	sed -e "s/NCBI_CFLAGS1 = -c/NCBI_CFLAGS1 = -c ${CFLAGS}/" \
		-e "s/NCBI_LDFLAGS1 = -O3 -mieee/NCBI_LDFLAGS1 = -mieee ${CFLAGS} ${LDFLAGS}/" \
		-e "s/NCBI_OPTFLAG = -O3 -mieee/NCBI_OPTFLAG = -mieee ${CFLAGS}/" \
		-i linux-alpha.ncbi.mk || die
	# ... on hppa...
	sed -e "s/NCBI_CFLAGS1 = -c/NCBI_CFLAGS1 = -c ${CFLAGS}/" \
		-e "s/NCBI_LDFLAGS1 = -O2/NCBI_LDFLAGS1 = ${CFLAGS} ${LDFLAGS}/" \
		-e "s/NCBI_OPTFLAG = -O2/NCBI_OPTFLAG = ${CFLAGS}/" \
		-i hppalinux.ncbi.mk || die
	# ... on ppc...
	sed -e "s/NCBI_CFLAGS1 = -c/NCBI_CFLAGS1 = -c ${CFLAGS}/" \
		-e "s/NCBI_LDFLAGS1 = -O2/NCBI_LDFLAGS1 = ${CFLAGS} ${LDFLAGS}/" \
		-e "s/NCBI_OPTFLAG = -O2/NCBI_OPTFLAG = ${CFLAGS}/" \
		-i ppclinux.ncbi.mk || die
	# ... on generic 64-bit Linux...
	sed -e "s/NCBI_CFLAGS1 = -c/NCBI_CFLAGS1 = -c ${CFLAGS}/" \
		-e "s/NCBI_LDFLAGS1 = -O3/NCBI_LDFLAGS1 = ${CFLAGS} ${LDFLAGS}/" \
		-e "s/NCBI_OPTFLAG = -O3/NCBI_OPTFLAG = ${CFLAGS}/" \
		-i linux64.ncbi.mk || die
	# ... on generic Linux.
	sed -e "s/NCBI_CFLAGS1 = -c/NCBI_CFLAGS1 = -c ${CFLAGS}/" \
		-e "s/NCBI_LDFLAGS1 = -O3/NCBI_LDFLAGS1 = ${CFLAGS} ${LDFLAGS}/" \
		-e "s/NCBI_OPTFLAG = -O3/NCBI_OPTFLAG = ${CFLAGS}/" \
		-i linux.ncbi.mk || die

	# Put in our MAKEOPTS (doesn't work).
	# sed -e "s:make \$MFLG:make ${MAKEOPTS}:" -i ncbi/make/makedis.csh

	# Set C compiler...
	# ... on x86...
	sed -i -e "s/NCBI_CC = gcc/NCBI_CC = $(tc-getCC)/" linux-x86.ncbi.mk || die
	# ... on alpha...
	sed -i -e "s/NCBI_CC = gcc/NCBI_CC = $(tc-getCC)/" linux-alpha.ncbi.mk || die
	# ... on hppa...
	sed -i -e "s/NCBI_CC = gcc/NCBI_CC = $(tc-getCC)/" hppalinux.ncbi.mk || die
	# ... on ppc...
	sed -i -e "s/NCBI_CC = gcc/NCBI_CC = $(tc-getCC)/" ppclinux.ncbi.mk || die
	# ... on generic 64-bit Linux...
	sed -i -e "s/NCBI_CC = gcc/NCBI_CC = $(tc-getCC)/" linux64.ncbi.mk || die
	# ... on generic Linux.
	sed -i -e "s/NCBI_CC = gcc/NCBI_CC = $(tc-getCC)/" linux.ncbi.mk || die

	# We use dynamic libraries
	sed -i -e "s/-Wl,-Bstatic//" *linux*.ncbi.mk || die

	sed \
		-re "s:/usr(/bin/.*sh):\1:g" \
		-e "s:(/bin/.*sh):${EPREFIX}\1:g" \
		-i $(find ${S} -type f) || die
}

src_compile() {
	export EXTRA_VIB
	cd "${WORKDIR}"
	csh ncbi/make/makedis.csh || die
	mkdir "${S}"/cgi
	mkdir "${S}"/real
	mv "${S}"/bin/*.cgi "${S}"/cgi || die
	mv "${S}"/bin/*.REAL "${S}"/real || die
	cd "${S}"/demo
	emake \
		-f ../make/makenet.unx \
		CC="$(tc-getCC) ${CFLAGS} -I../include  -L../lib" \
		LDFLAGS="${LDFLAGS}" \
		spidey || die
	cp spidey ../bin/ || die
}

src_install() {
	mv "${S}"/bin/cdscan "${S}"/bin/cdscan-ncbi #sci-geosciences/cdat-lite
	dobin "${S}"/bin/* || die "Failed to install binaries."
	for i in ${EXTRA_VIB}; do
		dobin "${S}"/build/${i} || die "Failed to install binaries."
	done
	dolib "${S}"/lib/* || die "Failed to install libraries."
	mkdir -p "${ED}"/usr/include/ncbi
	cp -RL "${S}"/include/* "${ED}"/usr/include/ncbi || \
		die "Failed to install headers."

	# TODO: wwwblast with webapps
	#insinto /usr/share/ncbi/lib/cgi
	#doins ${S}/cgi/*
	#insinto /usr/share/ncbi/lib/real
	#doins ${S}/real/*

	# Basic documentation
	dodoc "${S}"/{README,VERSION,doc/{*.txt,README.*}} || \
		die "Failed to install basic documentation."
	newdoc "${S}"/doc/fa2htgs/README README.fa2htgs || \
		die "Failed renaming fa2htgs documentation."
	newdoc "${S}"/config/README README.config || \
		die "Failed renaming config documentation."
	newdoc "${S}"/network/encrypt/README README.encrypt || \
		die "Failed renaming encrypt documentation."
	newdoc "${S}"/network/nsclilib/readme README.nsclilib || \
	die "Failed renaming nsclilib documentation."
	newdoc "${S}"/sequin/README README.sequin || \
		die "Failed renaming sequin documentation."
	doman "${S}"/doc/man/* || \
		die "Failed to install man pages."

	# Hypertext user documentation
	dohtml "${S}"/{README.htm,doc/{*.html,*.htm,*.gif}} || \
		die "Failed to install HTML documentation."
	insinto /usr/share/doc/${PF}/html/blast
	doins "${S}"/doc/blast/* || die "Failed to install blast HTML documentation."
	insinto /usr/share/doc/${PF}/html/images
	doins "${S}"/doc/images/* || die "Failed to install documentation images."
	insinto /usr/share/doc/${PF}/html/seq_install
	doins "${S}"/doc/seq_install/* || die "Failed to install seq_install documentation."

	# Developer documentation
	if use doc; then
		# Demo programs
		mkdir "${ED}"/usr/share/ncbi
		mv "${S}"/demo "${ED}"/usr/share/ncbi/demo || die
	fi

	# Shared data (similarity matrices and such) and database directory.
	insinto /usr/share/ncbi/data
	doins "${S}"/data/* || die "Failed to install shared data."
	dodir /usr/share/ncbi/formatdb || die

	# Default config file to set the path for shared data.
	insinto /etc/ncbi
	newins "${FILESDIR}"/ncbirc .ncbirc || die "Failed to install config file."

	# Env file to set the location of the config file and BLAST databases.
	newenvd "${FILESDIR}"/21ncbi-r1 21ncbi || die "Failed to install env file."
}
